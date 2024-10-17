#!/bin/bash

# Archivo que contiene las direcciones MAC
MAC_FILE="acceso.mac"

# Interfaces del firewall
INTERFACE_INT="enx00e04c360714"  # Interfaz interna (192.168.25.1)
INTERFACE_EXT="enp1s0"           # Interfaz externa (11.11.11.1)

# Funcion para inicializar el firewall
initialize_firewall() {
    # Eliminar todas las reglas de las tablas FILTER, NAT y MANGLE
    iptables -F
    iptables -t nat -F
    iptables -t mangle -F

    # Eliminar todas las cadenas definidas por el usuario
    iptables -X
    iptables -t nat -X
    iptables -t mangle -X

    # Restablecer las politicas predeterminadas a ACCEPT
    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT

    # Permitir conexiones SSH en el puerto 22
    iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    iptables -A FORWARD -p tcp --dport 22 -j ACCEPT

    # Bloquear todas las MACs en INPUT y FORWARD por defecto
    iptables -P INPUT DROP
    iptables -P FORWARD DROP

    echo "Política de todo cerrado aplicada"
}

# Funcion para permitir las MACs listadas en el archivo y agregar reglas de forwarding y NAT
allow_macs() {
    if [ -f "$MAC_FILE" ]; then
        while IFS= read -r mac; do
            # Eliminar cualquier regla que bloquee esta MAC
            iptables -D INPUT -m mac --mac-source "$mac" -j DROP 2>/dev/null
            iptables -D FORWARD -m mac --mac-source "$mac" -j DROP 2>/dev/null

            # Agregar regla para permitir la MAC
            iptables -A INPUT -m mac --mac-source "$mac" -j ACCEPT
            iptables -A FORWARD -m mac --mac-source "$mac" -j ACCEPT

            # Reglas de forwarding y NAT para la MAC permitida
            iptables -A FORWARD -i $INTERFACE_INT -o $INTERFACE_EXT -m mac --mac-source "$mac" -j ACCEPT
            iptables -A FORWARD -i $INTERFACE_EXT -o $INTERFACE_INT -m state --state RELATED,ESTABLISHED -m mac --mac-source "$mac" -j ACCEPT
            iptables -t nat -A POSTROUTING -o $INTERFACE_EXT -m mac --mac-source "$mac" -j MASQUERADE

            echo "MAC $mac permitida con reglas de forwarding y NAT."
        done < "$MAC_FILE"
    else
        echo "Archivo $MAC_FILE no encontrado."
    fi
}

# Funcion para bloquear las MACs listadas en el archivo
block_macs() {
    if [ -f "$MAC_FILE" ]; then
        while IFS= read -r mac; do
            # Eliminar cualquier regla que permita esta MAC
            iptables -D INPUT -m mac --mac-source "$mac" -j ACCEPT 2>/dev/null
            iptables -D FORWARD -m mac --mac-source "$mac" -j ACCEPT 2>/dev/null

            # Agregar regla para bloquear la MAC
            iptables -A INPUT -m mac --mac-source "$mac" -j DROP
            iptables -A FORWARD -m mac --mac-source "$mac" -j DROP

            echo "MAC $mac bloqueada."
        done < "$MAC_FILE"
    else
        echo "Archivo $MAC_FILE no encontrado."
    fi
}

# Main
case "$1" in
    allow)
        initialize_firewall
        allow_macs
        ;;
    block)
        initialize_firewall
        block_macs
        ;;
    *)
        initialize_firewall
        ;;
esac

# Guardar las reglas de iptables
iptables-save > /etc/iptables/rules.v4
ip6tables-save > /etc/iptables/rules.v6

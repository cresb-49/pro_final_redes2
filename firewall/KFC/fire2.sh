#!/bin/bash


#        .--.
#       |o_o |
#       |:_/ |
#      //   \ \
#     (|     | )
#    /'\_   _/`\
#    \___)=(___/  AYUDA!!!


# Archivo con las MACs permitidas
MAC_FILE="acceso.mac"
# MAC del host proxy
MAC_PROXY="00:e0:4c:36:0a:fb"

# Funcion para permitir las MACs listadas en el archivo
permitir() {
    ###############################################################################################################################################
    #   /$$$$$$$  /$$$$$$$$  /$$$$$$  /$$$$$$$  /$$        /$$$$$$   /$$$$$$  /$$   /$$ /$$$$$$$$  /$$$$$$        /$$      /$$  /$$$$$$   /$$$$$$ #
    # | $$__  $$| $$_____/ /$$__  $$| $$__  $$| $$       /$$__  $$ /$$__  $$| $$  | $$| $$_____/ /$$__  $$      | $$$    /$$$ /$$__  $$ /$$__  $$ #
    # | $$  \ $$| $$      | $$  \__/| $$  \ $$| $$      | $$  \ $$| $$  \ $$| $$  | $$| $$      | $$  \ $$      | $$$$  /$$$$| $$  \ $$| $$  \__/ #
    # | $$  | $$| $$$$$   |  $$$$$$ | $$$$$$$ | $$      | $$  | $$| $$  | $$| $$  | $$| $$$$$   | $$  | $$      | $$ $$/$$ $$| $$$$$$$$| $$       #
    # | $$  | $$| $$__/    \____  $$| $$__  $$| $$      | $$  | $$| $$  | $$| $$  | $$| $$__/   | $$  | $$      | $$  $$$| $$| $$__  $$| $$       #
    # | $$  | $$| $$       /$$  \ $$| $$  \ $$| $$      | $$  | $$| $$/$$ $$| $$  | $$| $$      | $$  | $$      | $$\  $ | $$| $$  | $$| $$    $$ #
    # | $$$$$$$/| $$$$$$$$|  $$$$$$/| $$$$$$$/| $$$$$$$$|  $$$$$$/|  $$$$$$/|  $$$$$$/| $$$$$$$$|  $$$$$$/      | $$ \/  | $$| $$  | $$|  $$$$$$/ #
    # |_______/ |________/ \______/ |_______/ |________/ \______/  \____ $$$ \______/ |________/ \______/       |__/     |__/|__/  |__/ \______/  #
    #                                                                   \__/                                                                      #
    ###############################################################################################################################################
    # Se agrega la mac del hproxy 00:e0:4c:36:0a:fb
    if [ -f "$MAC_FILE" ]; then
        while IFS= read -r mac; do
            # Eliminar cualquier regla que bloquee esta MAC
            iptables -D INPUT -m mac --mac-source "$mac" -j DROP 2>/dev/null
            iptables -D FORWARD -m mac --mac-source "$mac" -j DROP 2>/dev/null

            # Agregar regla para permitir la MAC
            iptables -A INPUT -m mac --mac-source "$mac" -j ACCEPT
            iptables -A FORWARD -m mac --mac-source "$mac" -j ACCEPT

            echo "MAC $mac permitida."
        done < "$MAC_FILE"
    else
        echo "Archivo $MAC_FILE no encontrado."
    fi

    #########################################################################################################
    #  /$$      /$$  /$$$$$$   /$$$$$$        /$$   /$$ /$$$$$$$  /$$$$$$$   /$$$$$$  /$$   /$$ /$$     /$$
    # | $$$    /$$$ /$$__  $$ /$$__  $$      | $$  | $$| $$__  $$| $$__  $$ /$$__  $$| $$  / $$|  $$   /$$/
    # | $$$$  /$$$$| $$  \ $$| $$  \__/      | $$  | $$| $$  \ $$| $$  \ $$| $$  \ $$|  $$/ $$/ \  $$ /$$/ 
    # | $$ $$/$$ $$| $$$$$$$$| $$            | $$$$$$$$| $$$$$$$/| $$$$$$$/| $$  | $$ \  $$$$/   \  $$$$/  
    # | $$  $$$| $$| $$__  $$| $$            | $$__  $$| $$____/ | $$__  $$| $$  | $$  >$$  $$    \  $$/   
    # | $$\  $ | $$| $$  | $$| $$    $$      | $$  | $$| $$      | $$  \ $$| $$  | $$ /$$/\  $$    | $$    
    # | $$ \/  | $$| $$  | $$|  $$$$$$/      | $$  | $$| $$      | $$  | $$|  $$$$$$/| $$  \ $$    | $$    
    # |__/     |__/|__/  |__/ \______/       |__/  |__/|__/      |__/  |__/ \______/ |__/  |__/    |__/    
    #########################################################################################################
    # Eliminar bloqueo de la MAC
    iptables -D INPUT -m mac --mac-source "$MAC_PROXY" -j DROP 2>/dev/null
    iptables -D FORWARD -m mac --mac-source "$MAC_PROXY" -j DROP 2>/dev/null
    # Permision de la MAC
    iptables -A INPUT -m mac --mac-source "$MAC_PROXY" -j ACCEPT
    iptables -A FORWARD -m mac --mac-source "$MAC_PROXY" -j ACCEPT
    #######################################################################
}

# Funcion para bloquear las MACs listadas en el archivo
bloquear() {
    ##############################################################################################################
    # /$$$$$$$  /$$        /$$$$$$   /$$$$$$  /$$   /$$ /$$$$$$$$  /$$$$$$        /$$      /$$  /$$$$$$   /$$$$$$ 
    #| $$__  $$| $$       /$$__  $$ /$$__  $$| $$  | $$| $$_____/ /$$__  $$      | $$$    /$$$ /$$__  $$ /$$__  $$
    #| $$  \ $$| $$      | $$  \ $$| $$  \ $$| $$  | $$| $$      | $$  \ $$      | $$$$  /$$$$| $$  \ $$| $$  \__/
    #| $$$$$$$ | $$      | $$  | $$| $$  | $$| $$  | $$| $$$$$   | $$  | $$      | $$ $$/$$ $$| $$$$$$$$| $$      
    #| $$__  $$| $$      | $$  | $$| $$  | $$| $$  | $$| $$__/   | $$  | $$      | $$  $$$| $$| $$__  $$| $$      
    #| $$  \ $$| $$      | $$  | $$| $$/$$ $$| $$  | $$| $$      | $$  | $$      | $$\  $ | $$| $$  | $$| $$    $$
    #| $$$$$$$/| $$$$$$$$|  $$$$$$/|  $$$$$$/|  $$$$$$/| $$$$$$$$|  $$$$$$/      | $$ \/  | $$| $$  | $$|  $$$$$$/
    #|_______/ |________/ \______/  \____ $$$ \______/ |________/ \______/       |__/     |__/|__/  |__/ \______/ 
    #                                \__/                                                                     
    ##############################################################################################################
    if [ -f "$MAC_FILE" ]; then
        while IFS= read -r mac; do
            # Eliminar la regla asociada a la MAC
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

# Funcion para inicializar el firewall
init_fire() {
    ####################################################################################
    #  /$$$$$$$$ /$$$$$$ /$$$$$$$  /$$$$$$$$ /$$      /$$  /$$$$$$  /$$       /$$      
    # | $$_____/|_  $$_/| $$__  $$| $$_____/| $$  /$ | $$ /$$__  $$| $$      | $$      
    # | $$        | $$  | $$  \ $$| $$      | $$ /$$$| $$| $$  \ $$| $$      | $$      
    # | $$$$$     | $$  | $$$$$$$/| $$$$$   | $$/$$ $$ $$| $$$$$$$$| $$      | $$      
    # | $$__/     | $$  | $$__  $$| $$__/   | $$$$_  $$$$| $$__  $$| $$      | $$      
    # | $$        | $$  | $$  \ $$| $$      | $$$/ \  $$$| $$  | $$| $$      | $$      
    # | $$       /$$$$$$| $$  | $$| $$$$$$$$| $$/   \  $$| $$  | $$| $$$$$$$$| $$$$$$$$
    # |__/      |______/|__/  |__/|________/|__/     \__/|__/  |__/|________/|________/
    #####################################################################################
    
    # Eliminar todas las reglas actuales de las tablas FILTER, NAT y MANGLE
    # Esto limpia las configuraciones previas en estas tablas para empezar de cero.
    iptables -F
    iptables -t nat -F
    iptables -t mangle -F

    # Eliminar todas las cadenas definidas por el usuario en las tablas FILTER, NAT y MANGLE
    # Se asegura de que no queden cadenas personalizadas que puedan interferir.
    iptables -X
    iptables -t nat -X
    iptables -t mangle -X

    # Restablecer las políticas predeterminadas de las cadenas INPUT, FORWARD y OUTPUT a ACCEPT
    # Esto significa que por defecto se permitirán todas las conexiones entrantes, reenviadas y salientes.
    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT

    # Permitir conexiones SSH en el puerto 22 tanto en INPUT como en FORWARD
    # Asegura que las conexiones SSH sean permitidas para administración remota del sistema.
    iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    iptables -A FORWARD -p tcp --dport 22 -j ACCEPT

    # Bloquear todas las conexiones entrantes (INPUT) y reenviadas (FORWARD) por defecto
    # A partir de este punto, cualquier conexión que no esté explícitamente permitida será bloqueada.
    iptables -P INPUT DROP
    iptables -P FORWARD DROP

    echo "TODO CERRADO"
}

# Función para mostrar el menú interactivo con selección numérica
menu() {
    while true; do
        echo "Menú de Firewall"
        echo "1. Inicializacion"
        echo "2. Permitir conexiones"
        echo "3. Bloquear conexiones"
        echo "4. Salir"
        echo -n "Elige una opción (1-4): "
        read opcion

        case $opcion in
            1)
                init_fire
                break
                ;;
            2)
                init_fire
                permitir
                break
                ;;
            3)
                init_fire
                bloquear
                break
                ;;
            4)
                echo "Saliendo..."
                exit 0
                ;;
            *)
                echo "Opción inválida, por favor elige una opción válida (1-3)."
                ;;
        esac
    done

    # Guardar las reglas de iptables
    iptables-save > /etc/iptables/rules.v4
    ip6tables-save > /etc/iptables/rules.v6
}

# Ejecutar el menú interactivo
menu

# # Guardar las reglas de iptables
# iptables-save > /etc/iptables/rules.v4
# ip6tables-save > /etc/iptables/rules.v6

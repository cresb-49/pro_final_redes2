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

reinicio_iptables(){
    # Elimina todas las reglas de la tabla filter, que es la tabla predeterminada en iptables
    sudo iptables -F        # Elimina todas las reglas en la tabla filter

    # Elimina todas las cadenas personalizadas en la tabla filter
    sudo iptables -X        # Elimina todas las cadenas personalizadas en la tabla filter

    # Elimina todas las reglas en la tabla nat, utilizada para la traducción de direcciones de red (NAT)
    sudo iptables -t nat -F # Elimina todas las reglas en la tabla nat

    # Elimina todas las cadenas personalizadas en la tabla nat
    sudo iptables -t nat -X # Elimina todas las cadenas personalizadas en la tabla nat

    # Elimina todas las reglas en la tabla mangle, utilizada para modificar campos específicos de los paquetes IP
    sudo iptables -t mangle -F # Elimina todas las reglas en la tabla mangle

    # Elimina todas las cadenas personalizadas en la tabla mangle
    sudo iptables -t mangle -X # Elimina todas las cadenas personalizadas en la tabla mangle

    # Elimina todas las reglas en la tabla raw, que se utiliza principalmente para decisiones de seguimiento de conexiones
    sudo iptables -t raw -F    # Elimina todas las reglas en la tabla raw

    # Elimina todas las cadenas personalizadas en la tabla raw
    sudo iptables -t raw -X    # Elimina todas las cadenas personalizadas en la tabla raw

    # Elimina todas las reglas en la tabla security, utilizada para aplicar políticas de seguridad adicionales (como SELinux)
    sudo iptables -t security -F # Elimina todas las reglas en la tabla security

    # Elimina todas las cadenas personalizadas en la tabla security
    sudo iptables -t security -X # Elimina todas las cadenas personalizadas en la tabla security

    # Establece la política predeterminada para las reglas INPUT (entrantes) a ACCEPT (aceptar todo el tráfico entrante)
    sudo iptables -P INPUT ACCEPT

    # Establece la política predeterminada para las reglas FORWARD (reenviadas) a ACCEPT (aceptar todo el tráfico reenviado)
    sudo iptables -P FORWARD ACCEPT

    # Establece la política predeterminada para las reglas OUTPUT (salientes) a ACCEPT (aceptar todo el tráfico saliente)
    sudo iptables -P OUTPUT ACCEPT

    # Guardar las reglas actuales de iptables en el archivo rules.v4 (para IPv4)
    sudo iptables-save > /etc/iptables/rules.v4

    # Guardar las reglas actuales de iptables en el archivo rules.v6 (para IPv6)
    sudo iptables-save > /etc/iptables/rules.v6

    # Baja la interfaz de red wlp2s0 (desactiva el adaptador inalámbrico)
    sudo ip link set wlp2s0 down

    # Elimina la ruta predeterminada actual (elimina la puerta de enlace predeterminada)
    sudo ip route del default

    # Agrega una nueva ruta predeterminada, definiendo una puerta de enlace específica para la red via 11.11.11.2 usando la interfaz enp1s0
    sudo ip route add default via 11.11.11.2 dev enp1s0

    echo "Reglas del firewall descartadas."

}

# Función para mostrar el menú interactivo con selección numérica
menu() {
    while true; do
        echo "Menú de Firewall"
        echo "1. Inicializacion"
        echo "2. Permitir conexiones"
        echo "3. Bloquear conexiones"
        echo "4. Reiniciar iptables"
        echo "5. Salir"
        echo -n "Elige una opción (1-5): "
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
                reinicio_iptables
                exit 0
                ;;  
            5)
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

menu


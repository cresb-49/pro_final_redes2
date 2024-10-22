#!/bin/bash


#        .--.
#       |o_o |
#       |:_/ |
#      //   \ \
#     (|     | )
#    /'\_   _/`\
#    \___)=(___/  AYUDA!!!


# Archivo que contiene las direcciones IP y sus limites de velocidad
ARCHIVO_CONF="bw.ip"


#  /$$$$$$$   /$$$$$$  /$$      /$$ /$$   /$$ /$$        /$$$$$$   /$$$$$$  /$$$$$$$ 
# | $$__  $$ /$$__  $$| $$  /$ | $$| $$$ | $$| $$       /$$__  $$ /$$__  $$| $$__  $$
# | $$  \ $$| $$  \ $$| $$ /$$$| $$| $$$$| $$| $$      | $$  \ $$| $$  \ $$| $$  \ $$
# | $$  | $$| $$  | $$| $$/$$ $$ $$| $$ $$ $$| $$      | $$  | $$| $$$$$$$$| $$  | $$
# | $$  | $$| $$  | $$| $$$$_  $$$$| $$  $$$$| $$      | $$  | $$| $$__  $$| $$  | $$
# | $$  | $$| $$  | $$| $$$/ \  $$$| $$\  $$$| $$      | $$  | $$| $$  | $$| $$  | $$
# | $$$$$$$/|  $$$$$$/| $$/   \  $$| $$ \  $$| $$$$$$$$|  $$$$$$/| $$  | $$| $$$$$$$/
# |_______/  \______/ |__/     \__/|__/  \__/|________/ \______/ |__/  |__/|_______/ 
# 
# Aplicacion de las reglas de descarga por los siguietnes parametros
# $1: IP en version IPv4
# $2: Velocidad de descarga en kbps
# $3: Identificador de clase
aplicar_bajada() {
    local ip=$1
    local id_clase=$2
    local v_descarga=$3
    # Convertir las velocidades de kbps a bps
    local v_descarga_bps=$((v_descarga * 1000))
    # Aplicando limites de ancho de banda de descarga de la IP y asignando una clase a la IP
    tc class add dev enx00e04c360714 parent 1: classid 1:$id_clase htb rate "${v_descarga_bps}bps" ceil "${v_descarga_bps}bps"
    tc filter add dev enx00e04c360714 protocol ip parent 1: prio 1 u32 match ip dst "$ip" flowid 1:$id_clase
    echo "Ancho de banda bajada para $ip => ${v_descarga} kbps."
}

aplicar_conf() {
    # qdisc para el manejo del trafico 
    tc qdisc add dev enx00e04c360714 root handle 1: htb default 30
    tc qdisc add dev enx00e04c360714 ingress handle ffff:

    if [ -f "$ARCHIVO_CONF" ]; then
        id_clase_descarga=150
        while IFS=, read -r ip v_descarga v_carga; do
            aplicar_bajada "$ip" "$id_clase_descarga" "$v_descarga"
            ((id_clase_descarga++))
            aplicar_subida "$ip" "$v_carga"
        done < "$ARCHIVO_CONF"
    else
        echo "Archivo $ARCHIVO_CONF no encontrado."
    fi
}


#  /$$   /$$ /$$$$$$$  /$$        /$$$$$$   /$$$$$$  /$$$$$$$ 
# | $$  | $$| $$__  $$| $$       /$$__  $$ /$$__  $$| $$__  $$
# | $$  | $$| $$  \ $$| $$      | $$  \ $$| $$  \ $$| $$  \ $$
# | $$  | $$| $$$$$$$/| $$      | $$  | $$| $$$$$$$$| $$  | $$
# | $$  | $$| $$____/ | $$      | $$  | $$| $$__  $$| $$  | $$
# | $$  | $$| $$      | $$      | $$  | $$| $$  | $$| $$  | $$
# |  $$$$$$/| $$      | $$$$$$$$|  $$$$$$/| $$  | $$| $$$$$$$/
#  \______/ |__/      |________/ \______/ |__/  |__/|_______/ 
                                                            
# Funcion para limitar el ancho de banda de una IP (subida)
# $1: IP en verison IPv4
# $2: Velocidad de subida en kbps
aplicar_subida() {
    local ip=$1
    local v_carga=$2
    # Convertir las velocidades de kbps a bps (bit por segundo)
    local v_carga_bps=$((v_carga * 1000))
    # qdisc de subida
    tc filter add dev enx00e04c360714 parent ffff: protocol ip u32 match ip src "$ip" police rate "${v_carga_bps}bps" burst 10k drop flowid :1
    echo "Ancho de banda subida para $ip => ${v_carga} kbps."
}


menu() {
    while true; do
        echo "Menú de Ancho de Banda"
        echo "1. Limitar ancho de banda"
        echo "2. Restaurar configuración"
        echo "3. Salir"
        echo -n "Elige una opción (1-3): "
        read opcion

        case $opcion in
            1)
                tc qdisc del dev enx00e04c360714 root 2>/dev/null
                tc qdisc del dev enx00e04c360714 ingress 2>/dev/null
                aplicar_conf
                ;;
            2)
                tc qdisc del dev enx00e04c360714 root 2>/dev/null
                tc qdisc del dev enx00e04c360714 ingress 2>/dev/null
                echo "Configuración restaurada."
                ;;
            3)
                echo "Saliendo..."
                exit 0
                ;;
            *)
                echo "Opción inválida, por favor elige una opción válida (1-3)."
                ;;
        esac
    done
}

menu

##################################################################################################################
#  /$$$$$$$  /$$$$$$$$ /$$$$$$$  /$$$$$$$$  /$$$$$$         /$$$$$$         /$$$$$$   /$$$$$$   /$$$$$$  /$$   /$$
# | $$__  $$| $$_____/| $$__  $$| $$_____/ /$$__  $$       /$$__  $$       /$$__  $$ /$$$_  $$ /$$__  $$| $$  | $$
# | $$  \ $$| $$      | $$  \ $$| $$      | $$  \__/      |__/  \ $$      |__/  \ $$| $$$$\ $$|__/  \ $$| $$  | $$
# | $$$$$$$/| $$$$$   | $$  | $$| $$$$$   |  $$$$$$         /$$$$$$/        /$$$$$$/| $$ $$ $$  /$$$$$$/| $$$$$$$$
# | $$__  $$| $$__/   | $$  | $$| $$__/    \____  $$       /$$____/        /$$____/ | $$\ $$$$ /$$____/ |_____  $$
# | $$  \ $$| $$      | $$  | $$| $$       /$$  \ $$      | $$            | $$      | $$ \ $$$| $$            | $$
# | $$  | $$| $$$$$$$$| $$$$$$$/| $$$$$$$$|  $$$$$$/      | $$$$$$$$      | $$$$$$$$|  $$$$$$/| $$$$$$$$      | $$
# |__/  |__/|________/|_______/ |________/ \______/       |________/      |________/ \______/ |________/      |__/
##################################################################################################################

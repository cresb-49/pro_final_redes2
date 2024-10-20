#!/bin/bash

# Archivo que contiene las direcciones IP y sus limites de velocidad
BW_FILE="bw.ip"

# Interface de red
IFACE="enx00e04c36015e"

# Limpiar todas las reglas previas de 'tc'
reset_tc() {
    tc qdisc del dev $IFACE root 2>/dev/null
    tc qdisc del dev $IFACE ingress 2>/dev/null
    echo "Se eliminaron todas las configuraciones anteriores de tc."
}

# Funcion para limitar el ancho de banda de una IP (descarga)
limit_download_bandwidth() {
    local ip=$1
    local download_speed=$2
    local classid=$3

    # Convertir las velocidades de kbps a bps (bit por segundo)
    local download_speed_bps=$((download_speed * 1000))

    # Limitar ancho de banda de descarga (tráfico de entrada, destino es la IP)
    tc class add dev $IFACE parent 1: classid 1:$classid htb rate "${download_speed_bps}bps" ceil "${download_speed_bps}bps"
    tc filter add dev $IFACE protocol ip parent 1: prio 1 u32 match ip dst "$ip" flowid 1:$classid

    echo "Ancho de banda de descarga para $ip limitado a ${download_speed} kbps."
}

# Funcion para limitar el ancho de banda de una IP (subida)
limit_upload_bandwidth() {
    local ip=$1
    local upload_speed=$2

    # Convertir las velocidades de kbps a bps (bit por segundo)
    local upload_speed_bps=$((upload_speed * 1000))

    # Limitar ancho de banda de subida usando el qdisc ingress
    tc filter add dev $IFACE parent ffff: protocol ip u32 match ip src "$ip" police rate "${upload_speed_bps}bps" burst 10k drop flowid :1

    echo "Ancho de banda de subida para $ip limitado a ${upload_speed} kbps."
}

# Funcion principal que aplica las restricciones de ancho de banda
apply_bandwidth_limits() {
    # Configurar qdisc para manejar el tráfico de descarga
    tc qdisc add dev $IFACE root handle 1: htb default 30

    # Configurar qdisc ingress para manejar el tráfico de subida
    tc qdisc add dev $IFACE ingress handle ffff:

    # Leer el archivo de configuracion y aplicar los limites de ancho de banda
    if [ -f "$BW_FILE" ]; then
        classid_download=10
        while IFS=, read -r ip download_speed upload_speed; do
            # Limitar el ancho de banda de descarga
            limit_download_bandwidth "$ip" "$download_speed" "$classid_download"
            ((classid_download++))  # Incrementar classid para la siguiente IP

            # Limitar el ancho de banda de subida
            limit_upload_bandwidth "$ip" "$upload_speed"
        done < "$BW_FILE"
    else
        echo "Archivo $BW_FILE no encontrado."
    fi
}

# Main
case "$1" in
    reset)
        reset_tc
        ;;
    apply)
        reset_tc
        apply_bandwidth_limits
        ;;
    *)
        echo "Uso: $0 {apply|reset}"
        ;;
esac

echo "Configuracion de ancho de banda completada."

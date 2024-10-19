#!/bin/bash

# Archivo que contiene las direcciones IP y sus limites de velocidad
BW_FILE="bw.ip"

# Interface de red
IFACE="eth0"

# Limpiar todas las reglas previas de 'tc'
reset_tc() {
    tc qdisc del dev $IFACE root 2>/dev/null
    echo "Se eliminaron todas las configuraciones anteriores de tc."
}

# Funcion para limitar el ancho de banda de una IP
limit_bandwidth() {
    local ip=$1
    local download_speed=$2
    local upload_speed=$3
    local classid_download=$4
    local classid_upload=$5

    # Convertir las velocidades de kbps a bps (bit por segundo)
    local download_speed_bps=$((download_speed * 1000))
    local upload_speed_bps=$((upload_speed * 1000))

    # Limitar ancho de banda de descarga (ingreso al host)
    tc class add dev $IFACE parent 1: classid 1:$classid_download htb rate "${download_speed_bps}bps" ceil "${download_speed_bps}bps"
    tc filter add dev $IFACE protocol ip parent 1: prio 1 u32 match ip dst "$ip" flowid 1:$classid_download

    # Limitar ancho de banda de subida (egreso desde el host)
    tc class add dev $IFACE parent 1: classid 1:$classid_upload htb rate "${upload_speed_bps}bps" ceil "${upload_speed_bps}bps"
    tc filter add dev $IFACE protocol ip parent 1: prio 1 u32 match ip src "$ip" flowid 1:$classid_upload

    echo "Ancho de banda para $ip limitado a ${download_speed} kbps (bajada) y ${upload_speed} kbps (subida)."
}

# Funcion principal que aplica las restricciones de ancho de banda
apply_bandwidth_limits() {
    # Configurar qdisc
    tc qdisc add dev $IFACE root handle 1: htb default 30

    # Leer el archivo de configuracion y aplicar los limites de ancho de banda
    if [ -f "$BW_FILE" ]; then
        classid_download=10
        classid_upload=100  # Iniciar las clases de subida en un rango diferente
        while IFS=, read -r ip download_speed upload_speed; do
            # Limitar el ancho de banda para la IP dada con clases únicas para subida y bajada
            limit_bandwidth "$ip" "$download_speed" "$upload_speed" "$classid_download" "$classid_upload"
            ((classid_download++))  # Incrementar el classid para cada IP (bajada)
            ((classid_upload++))    # Incrementar el classid para cada IP (subida)
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

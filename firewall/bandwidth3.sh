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
    local speed=$2
    local classid=$3

    # Convertir la velocidad de kbps a bps (bit por segundo)
    local speed_bps=$((speed * 1000))

    # Crear la clase y la regla para limitar el ancho de banda para la IP especificada
    tc class add dev $IFACE parent 1: classid 1:$classid htb rate "${speed_bps}bps" ceil "${speed_bps}bps"
    tc filter add dev $IFACE protocol ip parent 1: prio 1 u32 match ip dst "$ip" flowid 1:$classid

    echo "Ancho de banda para $ip limitado a $speed kbps (clase 1:$classid)."
}

# Funcion principal que aplica las restricciones de ancho de banda
apply_bandwidth_limits() {
    # Configurar qdisc
    tc qdisc add dev $IFACE root handle 1: htb default 30

    # Leer el archivo de configuracion y aplicar los limites de ancho de banda
    if [ -f "$BW_FILE" ]; then
        classid=10
        while IFS=, read -r ip speed; do
            # Limitar el ancho de banda para la IP dada con una clase única
            limit_bandwidth "$ip" "$speed" "$classid"
            ((classid++))  # Incrementar el classid para cada IP
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

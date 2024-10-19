#!/bin/bash

# Archivo que contiene las direcciones IP y sus limites de velocidad en kbps
BW_FILE="bw.ip"

# Interface de red
IFACE="eth0"

# Limpiar todas las reglas previas de 'tc'
reset_tc() {
    # Borra cualquier configuración previa de 'tc' en la interfaz especificada
    tc qdisc del dev $IFACE root 2>/dev/null
    echo "Se eliminaron todas las configuraciones anteriores de tc."
}

# Función para limitar el ancho de banda de una IP específica
limit_bandwidth() {
    local ip=$1   # Dirección IP
    local speed=$2   # Velocidad en kbps

    # Convertir la velocidad de kbps a bps (bit por segundo)
    local speed_bps=$((speed * 1000))

    # Crear la clase HTB (Hierarchical Token Bucket) para la IP con el ancho de banda especificado
    tc class add dev $IFACE parent 1: classid 1:1 htb rate "${speed_bps}bps" ceil "${speed_bps}bps"

    # Crear el filtro que aplicará el límite de ancho de banda a la IP
    tc filter add dev $IFACE protocol ip parent 1: prio 1 u32 match ip dst "$ip" flowid 1:1

    echo "Ancho de banda para $ip limitado a $speed kbps."
}

# Función principal que aplica las restricciones de ancho de banda
apply_bandwidth_limits() {
    # Configurar la raíz de la cola (qdisc) HTB
    tc qdisc add dev $IFACE root handle 1: htb default 30

    # Verificar si el archivo de configuración de ancho de banda existe
    if [ -f "$BW_FILE" ]; then
        # Leer el archivo línea por línea, cada línea debe tener IP y velocidad en kbps (separados por coma)
        while IFS=, read -r ip speed; do
            # Limitar el ancho de banda para la IP dada
            limit_bandwidth "$ip" "$speed"
        done < "$BW_FILE"
    else
        echo "Archivo $BW_FILE no encontrado."
    fi
}

# Main - Determina si se debe aplicar las reglas o resetearlas
case "$1" in
    reset)
        reset_tc   # Llama a la función para resetear (borrar) las reglas anteriores
        ;;
    apply)
        reset_tc   # Resetea las reglas anteriores antes de aplicar las nuevas
        apply_bandwidth_limits   # Aplica las nuevas reglas desde el archivo bw.ip
        ;;
    *)
        echo "Uso: $0 {apply|reset}"   # Mensaje de ayuda en caso de un argumento incorrecto
        ;;
esac

echo "Configuración de ancho de banda completada."

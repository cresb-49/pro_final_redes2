#!/bin/bash

#Se eliminan las reglas del firewall (reinicio)
sudo iptables -F        # Elimina todas las reglas en la tabla filter
sudo iptables -X        # Elimina todas las cadenas personalizadas
sudo iptables -t nat -F # Elimina todas las reglas en la tabla nat
sudo iptables -t nat -X # Elimina todas las cadenas personalizadas en la tabla nat
sudo iptables -t mangle -F # Elimina todas las reglas en la tabla mangle
sudo iptables -t mangle -X # Elimina todas las cadenas personalizadas en la tabla mangle
sudo iptables -t raw -F    # Elimina todas las reglas en la tabla raw
sudo iptables -t raw -X    # Elimina todas las cadenas personalizadas en la tabla raw
sudo iptables -t security -F # Elimina todas las reglas en la tabla security
sudo iptables -t security -X # Elimina todas las cadenas personalizadas en la tabla security

sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT

# Guardar las reglas de iptables
sudo iptables-save > /etc/iptables/rules.v4
sudo iptables-save > /etc/iptables/rules.v6

echo "Reglas de iptables reiniciadas."

sudo ip link set wlp4s0 down
sudo ip route del default
sudo ip route add default via 192.168.1.2 dev enx00e04c360131

#!/bin/bash

# Bloquea todo el tráfico de entrada y salida inicialmente
sudo iptables -A INPUT -m mac ! --mac-source 00:00:00:00:00:00 -j DROP
sudo iptables -A FORWARD -m mac ! --mac-source 00:00:00:00:00:00 -j DROP

# Guardar las reglas de iptables
sudo iptables-save > /etc/iptables/rules.v4

echo "Politica todo cerrado activa."

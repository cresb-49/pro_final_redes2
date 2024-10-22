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

# Bloquea todo el tráfico de entrada y salida inicialmente
sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT DROP
sudo iptables -P FORWARD DROP

# Permite el tráfico de loopback (necesario para el sistema)
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

# Guardar las reglas de iptables
sudo iptables-save > /etc/iptables/rules.v4

echo "Politica todo cerrado activa."

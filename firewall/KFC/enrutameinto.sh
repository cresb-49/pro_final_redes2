#!/bin/bash

# En PC2 (Firewall)
#sudo iptables -t nat -A POSTROUTING -o enp1s0 -j MASQUERADE

# Permitir tráfico desde PC1 (enx00e04c360714) hacia PC3 (enp1s0)
#sudo iptables -A FORWARD -i enx00e04c360714 -o enp1s0 -j ACCEPT
# Permitir las respuestas desde PC3 (enp1s0) hacia PC1 (enx00e04c360714)
#sudo iptables -A FORWARD -i enp1s0 -o enx00e04c360714 -m state --state RELATED,ESTABLISHED -j ACCEPT

# Eliminamos la default gateway
sudo ip route del default
# Configurar la ruta predeterminada en PC2 para que apunte hacia PC3
sudo ip route add default via 11.11.11.2 dev enp1s0

#Configuracion para wordpress
#sudo iptables -t nat -A POSTROUTING -o enx00e04c360714 -j MASQUERADE
#sudo iptables -A FORWARD -i enp1s0 -o enx00e04c360714 -j ACCEPT
#sudo iptables -A FORWARD -i enx00e04c360714 -o enp1s0 -m state --state RELATED,ESTABLISHED -j ACCEPT

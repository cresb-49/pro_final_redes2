#!/bin/bash

#Debemos de configurar la ruta a la red interna 192.168.25.0/24 por la interzafaz enx00e04c360afb por la ip 11.11.11.1
sudo ip route add 192.128.25.0/24 via 11.11.11.1 dev enx00e04c360afb

# En PC3 (11.11.11.2)
sudo iptables -t nat -A POSTROUTING -o wlp0s20f3 -j MASQUERADE


# Permitir tráfico desde PC2 (enp1s0) hacia internet
sudo iptables -A FORWARD -i enp1s0 -o wlp0s20f3 -j ACCEPT
# Permitir las respuestas desde internet hacia PC2
sudo iptables -A FORWARD -i wlp0s20f3 -o enp1s0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# ALTERNATICA EN CASO DE FALLO
# Permitir tráfico desde PC2 (enp1s0) hacia internet
# sudo iptables -A FORWARD -i enx00e04c360afb -o wlp0s20f3 -j ACCEPT
# Permitir las respuestas desde internet hacia PC2
# sudo iptables -A FORWARD -i wlp0s20f3 -o enx00e04c360afb -m state --state RELATED,ESTABLISHED -j ACCEPT

#!/bin/bash

# En PC3 (11.11.11.2)
sudo iptables -t nat -A POSTROUTING -o wlp0s20f3 -j MASQUERADE

# ALTERNATICA EN CASO DE FALLO
# Permitir tráfico desde PC2 (enp1s0) hacia internet
# sudo iptables -A FORWARD -i enp1s0 -o wlp0s20f3 -j ACCEPT
# Permitir las respuestas desde internet hacia PC2
# sudo iptables -A FORWARD -i wlp0s20f3 -o enp1s0 -m state --state RELATED,ESTABLISHED -j ACCEPT


# Permitir tráfico desde PC2 (enp1s0) hacia internet
sudo iptables -A FORWARD -i enx00e04c360afb -o wlp0s20f3 -j ACCEPT
# Permitir las respuestas desde internet hacia PC2
sudo iptables -A FORWARD -i wlp0s20f3 -o enx00e04c360afb -m state --state RELATED,ESTABLISHED -j ACCEPT

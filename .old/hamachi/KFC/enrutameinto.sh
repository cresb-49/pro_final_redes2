#!/bin/bash

#Debemos de configurar la ruta a la red interna 192.168.25.0/24 por la interzafaz enx00e04c360afb por la ip 11.11.11.1
sudo ip route add 192.168.25.0/24 via 11.11.11.1 dev enx00e04c360afb

# En PC3 (11.11.11.2)
sudo iptables -t nat -A POSTROUTING -o wlp0s20f3 -j MASQUERADE


# ALTERNATICA EN CASO DE FALLO
# Permitir tráfico desde PC2 (enp1s0) hacia internet
#sudo iptables -A FORWARD -i enp1s0 -o wlp0s20f3 -j ACCEPT
# Permitir las respuestas desde internet hacia PC2
#sudo iptables -A FORWARD -i wlp0s20f3 -o enp1s0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# Permitir tráfico desde PC2 (enp1s0) hacia internet
sudo iptables -A FORWARD -i enx00e04c360afb -o wlp0s20f3 -j ACCEPT
# Permitir las respuestas desde internet hacia PC2
sudo iptables -A FORWARD -i wlp0s20f3 -o enx00e04c360afb -m state --state RELATED,ESTABLISHED -j ACCEPT

# CONFIGURAR PROXY SQUID
sudo iptables -t nat -A PREROUTING -i enx00e04c360afb -p tcp --dport 80 -j REDIRECT --to-port 3128
sudo iptables -t nat -A PREROUTING -i enx00e04c360afb -p tcp --dport 443 -j REDIRECT --to-port 3129

# CONFIGURAR ROUTING DE RED HAMACHI

# Anterior --------------------------------------------------------------------------------------------
#sudo iptables -t nat -A POSTROUTING -o ham0 -j MASQUERADE
#sudo iptables -A FORWARD -i ham0 -o enx00e04c360afb -j ACCEPT
#sudo iptables -A FORWARD -i enx00e04c360afb -o ham0 -j ACCEPT
# -----------------------------------------------------------------------------------------------------

# Redirigir tráfico HTTP (puerto 80) desde la interfaz ham0 hacia 192.168.25.3
#sudo iptables -t nat -A PREROUTING -i ham0 -p tcp --dport 80 -j DNAT --to-destination 192.168.25.3:80

# Permitir el reenvío de tráfico de la interfaz ham0 hacia la red local
#sudo iptables -A FORWARD -i ham0 -o enx00e04c360afb -p tcp --dport 80 -d 192.168.25.3 -j ACCEPT

# Habilitar el enmascaramiento (NAT) para que las respuestas salgan correctamente a Hamachi
#sudo iptables -t nat -A POSTROUTING -o ham0 -j MASQUERADE

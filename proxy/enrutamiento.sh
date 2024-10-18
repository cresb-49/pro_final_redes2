#!/bin/bash

#ROUTING Y FORWARDING (Internet)
# Enmascaramiento Internet-Proxy (WiFi)
sudo iptables -t nat -A POSTROUTING -o wlp2s0 -j MASQUERADE

# Trafico FW-Proxy
sudo iptables -A FORWARD -i enp3s0 -o wlp2s0 -j ACCEPT

# Trafico Proxy-FW
sudo iptables -A FORWARD -i wlp2s0 -o enp3s0 -m state --state RELATED,ESTABLISHED -j ACCEPT


#HAMACHI (WordPress)
# Trafico Hamachi-Proxy (Port 80)
sudo iptables -t nat -A PREROUTING -i ham0 -p tcp --dport 80 -j DNAT --to-destination 192.168.100.3:80

# Trafico Hamachi-Proxy-FW (Reenvio)
sudo iptables -A FORWARD -i ham0 -o enp3s0 -p tcp --dport 80 -d 192.168.100.3 -j ACCEPT

# Enmascaramiento NAT Proxy-Hamachi
sudo iptables -t nat -A POSTROUTING -o ham0 -j MASQUERADE


#SQUID PROXY
#sudo iptables -t nat -A PREROUTING -i enp3s0 -p tcp --dport 80 -j REDIRECT --to-port 3128

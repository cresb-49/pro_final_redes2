#!/bin/bash

#INTERFACES
cat << EOL | sudo tee /etc/network/interfaces > /dev/null
source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

#Red Proxy-FW
auto enp3s0
iface enp3s0 inet static
#  address 192.168.1.2/30
  address 11.11.11.2/30
EOL


#RUTAS O VIAS
#Ruta Admin-FW
#ip route add 192.168.100.0/24 via 192.168.1.1 dev enp3s0
ip route add 192.168.25.0/24 via 11.11.11.1 dev enp3s0

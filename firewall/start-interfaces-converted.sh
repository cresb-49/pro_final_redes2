
#!/bin/bash
cat << EOL | sudo tee /etc/network/interfaces > /dev/null
source /etc/network/interfaces.d/*

#LOOPBACK NETWORK INTERFACE
auto lo
iface lo inet loopback

#RED PROXY
auto enx00e04c360131
iface enx00e04c360131 inet static
  address 192.168.1.1/30

#RED CLIENTE
auto enx00e04c36015e
iface enx00e04c36015e inet static
  address 192.168.100.1/24


EOL


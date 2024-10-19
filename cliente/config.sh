#APAGAR INTERFAZ enp1s0 (por ahi resolvia el DNS)
sudo ip link set enp1s0 down


#SERVIDOR DNS
cat << EOL | sudo tee /etc/resolv.conf > /dev/null
nameserver 8.8.8.8
nameserver 8.8.4.4

EOL

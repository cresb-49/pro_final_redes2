cat << EOL | sudo tee /etc/network/interfaces > /dev/null

auto lo
iface lo inet loopback

auto enp1s0
iface enp1s0 inet static
    address 11.11.11.1/30

auto enx00e04c360714
iface enx00e04c360714 inet static
    address 192.168.25.1/24

EOL

sudo systemctl restart networking.service

cat << EOL | sudo tee /etc/resolv.conf > /dev/null

servername 8.8.8.8
servername 8.8.4.4

EOL

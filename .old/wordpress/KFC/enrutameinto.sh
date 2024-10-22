#!/bin/bash
sudo ip route delete default
sudo ip route add default via 192.168.25.1 dev enp7s0
sudo ip route add 11.11.11.0/30 via 192.168.25.1 dev enp7s0
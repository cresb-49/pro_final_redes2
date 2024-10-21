#!/bin/bash

# Ejecutar start-interfaces.sh
./start-interfaces.sh

# Reiniciar el servicio de red
sudo systemctl restart networking

# Ejecutar restart.sh
./restart.sh

# Ejecutar config.sh
./config.sh

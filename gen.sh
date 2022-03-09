#!/bin/bash
clear
echo "Generating a configuration file."
sleep 1
sudo docker run -it --rm \
   -v "$PWD/synapse:/data" \
   -e SYNAPSE_SERVER_NAME=matrix.example.com \
   -e SYNAPSE_REPORT_STATS=yes \
   -e UID=CHUID \
   -e GID=CHGID \
   matrixdotorg/synapse:latest generate
wait #waits for all child background jobs to complete
echo "Generating a configuration file completed."

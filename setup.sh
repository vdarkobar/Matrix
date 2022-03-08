sudo apt update

wait -n

echo "Update completed."

sudo docker run -it --rm \
   -v "$PWD/synapse:/data" \
   -e SYNAPSE_SERVER_NAME=matrix.example.com \
   -e SYNAPSE_REPORT_STATS=yes \
   -e UID=1000 \
   -e GID=1000 \
   matrixdotorg/synapse:latest generate \

wait -n

echo "Job completed."

#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
source .env
apt-get update && apt-get upgrade -y
apt-get install -yq --no-install-recommends apt-utils
apt-get upgrade -yq ca-certificates
apt-get install -yq --no-install-recommends curl prometheus-node-exporter
#echo "Ollama is not installed. Installing now..."
#curl -fsSL https://ollama.com/install.sh | sh
#chmod +x local_serve.sh
#./local_serve.sh
#echo "Waiting for key generation..."
#sleep 5
#ollama pull mistral
pip install -r requirements.txt
echo "Grafana Begins"

# Install dependencies
apt-get install -yq apt-transport-https software-properties-common wget gnupg

# Add Grafana GPG key
mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor -o /etc/apt/keyrings/grafana.gpg

# Add Grafana repository
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | tee -a /etc/apt/sources.list.d/grafana.list

# Update package lists
apt-get update

# Install Grafana
echo "Grafana Dependency installation Completed"
apt-get install -yq grafana
echo "Grafana installation Completed"

# Start Grafana server
/usr/sbin/grafana-server --config=/etc/grafana/grafana.ini --homepath=/usr/share/grafana --packaging=docker &

echo "Grafana Server Started"

### Install Ngrok
#curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc | tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
#echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | tee /etc/apt/sources.list.d/ngrok.list
#apt-get update
#apt-get install -y ngrok
#
## Configure Ngrok
#echo "NGROK_TOKEN: $NGROK_TOKEN"
#NGROK_TOKEN=$NGROK_TOKEN
#ngrok config add-authtoken NGROK_TOKEN
#ngrok http http://localhost:8010 &
#ngrok http --log=ngrok_log.txt http://localhost:8010 &
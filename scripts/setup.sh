#!/bin/bash

# Check if the user has root privileges
if [ "$(id -u)" != "0" ]; then
    echo "Error: This script must be run as root."
    exit 1
fi

# Define the array of lines to be added
LINES=(
    "127.0..2 nuget.orderexecution.internal"
    "127.0.0.2 nuget.trad.tradestation.com"
    "127.0.0.3 wowtrader-qa.bs-eqs-usoh.nite.internal"
    "127.0.0.4 wowtrader-qa.orderexecution.internal"
    "127.0.0.5 wowtrader.orderexecution.internal"
    "127.0.0.6 wowtrader-stg.orderexecution.internal"
    "127.0.0.7 kafka.use2.orderexecution.internal"
    "127.0.0.8 kafka.orderexecution.internal"
    "127.0.0.9 kafka.oxv3.use2.orderexecution.internal"
    "127.0.0.10 kafka.dump.orderexecution.internal"
    "127.0.0.11 grpc-qa1-tools-streaming-balances.bs-eqs-usoh.nite.tradestation.io"
    "127.0.0.12 172.27.32.21"
)

# Loop through each line
for LINE in "${LINES[@]}"; do
    # Check if the line already exists in the file
    grep -qF "$LINE" /etc/hosts

    # $? captures the exit status of the last command.
    # grep will exit with 0 if the line was found, and 1 if not.
    if [ $? -ne 0 ]; then
        # Line not found, so add it
        echo "$LINE" >> /etc/hosts
        echo "Added: $LINE"
    else
        echo "Already exists: $LINE"
    fi
done

apt remove -y awscli

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm awscliv2.zip
rm -fr aws
mv /usr/local/bin/aws /usr/bin/aws

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/bin/kubectl
rm ./kubectl

apt-get install -y ucspi-tcp

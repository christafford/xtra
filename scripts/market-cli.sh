#!/bin/bash

# Set the local file path
LOCAL_FILE_PATH="/tmp/libgomp.so.1"

# Step 1: Copy from Docker container to local host

# Get the container ID
CONTAINER_ID=$(docker ps | grep "vsc-marketdata" | awk '{ print $1 }' | head -n 1)

if [[ -z $CONTAINER_ID ]]; then
  echo "Container not found!"
  exit 1
fi

docker cp $CONTAINER_ID:/usr/lib/x86_64-linux-gnu/libgomp.so.1.0.0 $LOCAL_FILE_PATH

if [[ $? -ne 0 ]]; then
  echo "Error copying file from Docker container."
  exit 1
fi

# Step 2: Copy from local host to Kubernetes pod

NAMESPACE="ox-account-processor-qa"
POD_NAME="ox-account-processor-0"

kubectl cp $LOCAL_FILE_PATH $NAMESPACE/$POD_NAME:/usr/lib/x86_64-linux-gnu/

if [[ $? -ne 0 ]]; then
  echo "Error copying file to Kubernetes pod."
  exit 1
fi

echo "File copied successfully!"

# Cleanup: Optionally remove the file from the local host
rm -f $LOCAL_FILE_PATH

kubectl -n ox-account-processor-qa cp ~/code/tradestation/execution-services/oxv3/libraries/marketdata-ox/build/lib/libg3log.so.2 ox-account-processor-0:/usr/lib/x86_64-linux-gnu/
kubectl -n ox-account-processor-qa cp ~/code/tradestation/execution-services/oxv3/libraries/marketdata-ox/build/marketdata-cli ox-account-processor-0:/app/marketdata-cli

echo "Testing..."

kubectl -n ox-account-processor-qa exec -it ox-account-processor-0 -- /app/marketdata-cli "REQUEST 7,10,31 FROM SYMBOL_DATA WHERE 31=\"AAPL\""


#!/bin/bash

# Configuration
source ./dev-scripts/env.sh
source ./dev-scripts/utils.sh
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Please provide token addresses/denoms"
    echo "Usage: ./createPair.sh <token1_address/denom> <token2_address/denom>"
    exit 1
fi

TOKEN1=$1
TOKEN2=$2



ASSET1=$(create_asset_json $TOKEN1)
ASSET2=$(create_asset_json $TOKEN2)
echo $ASSET1
echo $ASSET2

# Create pair
echo "Creating pair..."
terrad tx wasm execute $FACTORY_CONTRACT_ADDRESS \
    "{\"create_pair\":{\"assets\":[$ASSET1,$ASSET2]}}" \
    --from $KEYNAME \
    --chain-id $CHAIN_ID \
    --gas $GAS \
    --fees 124975000uluna \
    --node $NODE \
    --broadcast-mode sync \
    --keyring-backend $KEYRING \
    -y \
    -o json






#!/bin/bash

# Configuration
source ./dev-scripts/env.sh

if [ -z "$1" ]; then
    echo "Please provide token address/denom"
    echo "Usage: ./queryAsset.sh <token_address/denom>"
    exit 1
fi

TOKEN=$1

# Check if input is contract address or denom
if [[ $TOKEN == terra* ]]; then
    # Query CW20 token info
    echo "Querying CW20 token info..."
    terrad query wasm contract-state smart $TOKEN \
        '{"token_info":{}}' \
        --node $NODE \
        --chain-id $CHAIN_ID \
        -o json
else
    # Query native token decimals from factory
    echo "Querying native token decimals..."
    terrad query wasm contract-state smart $FACTORY_CONTRACT_ADDRESS \
        "{\"native_token_decimals\":{\"denom\":\"$TOKEN\"}}" \
        --node $NODE \
        --chain-id $CHAIN_ID \
        -o json
fi 
#!/bin/bash

# Configuration
source ./dev-scripts/env.sh

# deployer address
DEPLOYER_ADDRESS=$(terrad keys show $KEYNAME -a --keyring-backend $KEYRING)
echo "DEPLOYER_ADDRESS: $DEPLOYER_ADDRESS"

if [ -z "$FACTORY_CONTRACT_ADDRESS" ]; then
    echo "Please provide a factory contract address"
    echo "Usage: ./instantiate.sh <factory_contract_address>"
    exit 1
fi

# Create the JSON message with proper escaping
INIT_MSG=$(cat << EOF
{
  "terraswap_factory": "$FACTORY_CONTRACT_ADDRESS"
}
EOF
)

echo "INIT_MSG: $INIT_MSG"
echo "ROUTER_CODE_ID: $ROUTER_CODE_ID"
# Instantiate the contract
echo "Instantiating contract..."
terrad tx wasm instantiate $ROUTER_CODE_ID "$INIT_MSG" \
    --label "LUNC Terraswap Router" \
    --from $KEYNAME \
    --chain-id $CHAIN_ID \
    --gas $GAS \
    --fees 124975000uluna \
    --node $NODE \
    --broadcast-mode sync \
    --keyring-backend $KEYRING \
    --admin $(terrad keys show $KEYNAME -a --keyring-backend $KEYRING) \
    -y \
    -o json

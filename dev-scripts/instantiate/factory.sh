#!/bin/bash

# Configuration
source ./dev-scripts/env.sh

if [ -z "$FACTORY_CODE_ID" ]; then
    echo "Please provide a code ID"
    echo "Usage: ./instantiate.sh <code_id>"
    exit 1
fi

if [ -z "$TOKEN_CODE_ID" ]; then
    echo "Please provide a token code ID"
    echo "Usage: ./instantiate.sh <token_code_id>"
    exit 1
fi

# deployer address
DEPLOYER_ADDRESS=$(terrad keys show $KEYNAME -a --keyring-backend $KEYRING)
echo "DEPLOYER_ADDRESS: $DEPLOYER_ADDRESS"

# Create the JSON message with proper escaping
INIT_MSG=$(cat << EOF
{
  "token_code_id": $TOKEN_CODE_ID,
  "pair_code_id": $PAIR_CODE_ID
}
EOF
)

# Instantiate the contract
echo "Instantiating contract..."
terrad tx wasm instantiate $FACTORY_CODE_ID "$INIT_MSG" \
    --label "LUNC Terraswap Factory" \
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

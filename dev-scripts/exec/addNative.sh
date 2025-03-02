#!/bin/bash

# Configuration
source ./dev-scripts/env.sh

## add native token 

terrad tx wasm execute $FACTORY_CONTRACT_ADDRESS \
    "{\"add_native_token_decimals\":{\"denom\":\"uluna\",\"decimals\":6}}" \
    --from $KEYNAME \
    --chain-id $CHAIN_ID \
    --gas $GAS \
    --fees 124975000uluna \
    --amount 1000000uluna \
    --node $NODE \
    --broadcast-mode sync \
    --keyring-backend $KEYRING \
    -y \
    -o json


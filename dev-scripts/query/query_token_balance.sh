#!/bin/bash

source ./dev-scripts/env.sh

# Query balance
echo "Querying token balance..."
terrad query wasm contract-state smart $TOKEN_CONTRACT_ADDRESS \
    '{
        "balance": {
            "address": "'$(terrad keys show $KEYNAME -a --keyring-backend test)'"
        }
    }' \
    --node $NODE \
    --chain-id $CHAIN_ID \
    --output json
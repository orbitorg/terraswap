#!/bin/bash

# Configuration
source ./dev-scripts/env.sh
source ./dev-scripts/utils.sh

# Default values or from arguments
TOKEN1=${1:-"uluna"}
AMOUNT=${2:-"1000000"}
TOKEN2=${3:-$TOKEN_CONTRACT_ADDRESS}
MIN_RECEIVE=${4:-"0"}
DEADLINE=${5:-$(($(date +%s) + 120))} # Default 2 minutes from now

# Create asset infos for the swap operation
OFFER_ASSET_INFO=$(create_asset_info_json $TOKEN1)
ASK_ASSET_INFO=$(create_asset_info_json $TOKEN2)

# Create the swap operation message
SWAP_MSG=$(cat << EOF
{
  "execute_swap_operations": {
    "operations": [
      {
        "terra_swap": {
          "offer_asset_info": $OFFER_ASSET_INFO,
          "ask_asset_info": $ASK_ASSET_INFO
        }
      }
    ],
    "minimum_receive": "$MIN_RECEIVE",
    "deadline": $DEADLINE
  }
}
EOF
)

echo "Swap Message: $SWAP_MSG"

# Prepare funds if offering native token
FUNDS=""
if [[ $TOKEN1 != terra* ]]; then
    FUNDS="--amount $AMOUNT$TOKEN1"
fi

# If token1 is CW20, need to send tokens to router via Cw20 Send
if [[ $TOKEN1 == terra* ]]; then
    echo "Sending CW20 tokens to router..."
    SEND_MSG=$(cat << EOF
{
  "send": {
    "contract": "$ROUTER_CONTRACT_ADDRESS",
    "amount": "$AMOUNT",
    "msg": "$(echo $SWAP_MSG | base64)"
  }
}
EOF
)
    
    terrad tx wasm execute $TOKEN1 "$SEND_MSG" \
        --from $KEYNAME \
        --chain-id $CHAIN_ID \
        --gas $GAS \
        --fees 124975000uluna \
        --node $NODE \
        --broadcast-mode sync \
        --keyring-backend $KEYRING \
        -y
else
    # Execute swap directly through router for native tokens
    echo "Executing swap through router..."
    terrad tx wasm execute $ROUTER_CONTRACT_ADDRESS "$SWAP_MSG" \
        --from $KEYNAME \
        --chain-id $CHAIN_ID \
        --gas $GAS \
        --fees 124975000uluna \
        $FUNDS \
        --node $NODE \
        --broadcast-mode sync \
        --keyring-backend $KEYRING \
        -y
fi





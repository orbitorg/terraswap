#!/bin/bash

# Configuration
source ./dev-scripts/env.sh
source ./dev-scripts/utils.sh

echo "Usage: ./provideLiquidity.sh <token1_address/denom> <amount1> <token2_address/denom> <amount2>"


TOKEN1=${1:-"uluna"}
AMOUNT1=${2:-"1000000000000"}
TOKEN2=${3:-$TOKEN_CONTRACT_ADDRESS}
AMOUNT2=${4:-"1000000000000"}

# Query pair address from factory
PAIR_QUERY="{\"pair\":{\"asset_infos\":[$(create_asset_info_json $TOKEN1),$(create_asset_info_json $TOKEN2)]}}"
PAIR_INFO=$(terrad query wasm contract-state smart $FACTORY_CONTRACT_ADDRESS "$PAIR_QUERY" --node $NODE -o json)
PAIR_CONTRACT=$(echo $PAIR_INFO | jq -r '.data.contract_addr')

echo "PAIR_CONTRACT: $PAIR_CONTRACT"


ASSET1=$(create_asset_json $TOKEN1 $AMOUNT1)
ASSET2=$(create_asset_json $TOKEN2 $AMOUNT2)

# If first token is CW20, need to increase allowance first
if [[ $TOKEN1 == terra* ]]; then
    echo "Increasing allowance for token 1..."
    terrad tx wasm execute $TOKEN1 \
        "{\"increase_allowance\":{\"spender\":\"$PAIR_CONTRACT\",\"amount\":\"$AMOUNT1\"}}" \
        --from $KEYNAME \
        --chain-id $CHAIN_ID \
        --gas $GAS \
        --fees 124975000uluna \
        --node $NODE \
        --broadcast-mode sync \
        --keyring-backend $KEYRING \
        -y > /dev/null 2>&1
fi

# If second token is CW20, need to increase allowance first
if [[ $TOKEN2 == terra* ]]; then
    echo "Increasing allowance for token 2..."
    terrad tx wasm execute $TOKEN2 \
        "{\"increase_allowance\":{\"spender\":\"$PAIR_CONTRACT\",\"amount\":\"$AMOUNT2\"}}" \
        --from $KEYNAME \
        --chain-id $CHAIN_ID \
        --gas $GAS \
        --fees 124975000uluna \
        --node $NODE \
        --broadcast-mode sync \
        --keyring-backend $KEYRING \
        -y > /dev/null 2>&1
fi


# Prepare native token funds if needed
FUNDS=""
if [[ $TOKEN1 != terra* ]]; then
    FUNDS="$FUNDS--amount $AMOUNT1$TOKEN1 "
fi
if [[ $TOKEN2 != terra* ]]; then
    FUNDS="$FUNDS--amount $AMOUNT2$TOKEN2 "
fi

echo "FUNDS: $FUNDS"


# Provide liquidity
echo "Providing liquidity..."
echo "ASSET1: $ASSET1"
echo "ASSET2: $ASSET2"
echo "PAIR_CONTRACT: $PAIR_CONTRACT"

terrad tx wasm execute $PAIR_CONTRACT \
    "{\"provide_liquidity\":{\"assets\":[$ASSET1,$ASSET2]}}" \
    --from $KEYNAME \
    --chain-id $CHAIN_ID \
    --gas $GAS \
    --fees 124975000uluna \
    $FUNDS \
    --node $NODE \
    --broadcast-mode sync \
    --keyring-backend $KEYRING \
    -y \
    -o json 
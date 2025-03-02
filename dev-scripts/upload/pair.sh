#!/bin/bash

# Configuration
CHAIN_ID="rebel-2" 
NODE="https://rpc.luncblaze.com:443"
KEYNAME="orbit-testnet"  
CONTRACT_PATH="artifacts/terraswap_pair.wasm"
GAS_PRICES="0.015uluna"
GAS="16196971"


# Upload the contract
echo "Uploading contract..."
terrad tx wasm store $CONTRACT_PATH \
  --from $KEYNAME \
  --chain-id $CHAIN_ID \
  --gas $GAS \
  --node $NODE \
  --fees 575529204uluna \
  --keyring-backend file \
  -y \
  -o json


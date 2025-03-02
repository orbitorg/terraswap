#!/bin/bash

# Create asset info JSON (without amount)
create_asset_info_json() {
    local input=$1
    if [[ $input == terra* ]]; then
        echo "{\"token\":{\"contract_addr\":\"$input\"}}"
    else
        echo "{\"native_token\":{\"denom\":\"$input\"}}"
    fi
}

# Create full asset JSON with amount
create_asset_json() {
    local input=$1
    local amount=${2:-"0"} # Default amount to "0" if not provided
    if [[ $input == terra* ]]; then
        echo "{\"info\":{\"token\":{\"contract_addr\":\"$input\"}},\"amount\":\"$amount\"}"
    else
        echo "{\"info\":{\"native_token\":{\"denom\":\"$input\"}},\"amount\":\"$amount\"}"
    fi
}
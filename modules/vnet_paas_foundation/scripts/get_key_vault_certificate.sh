#!/bin/bash

set -e

cert_name="$1"
vault_name="$2"

public_cer="$(az keyvault certificate show \
  --name "$cert_name" \
  --vault-name "$vault_name" \
  --query cer \
  --output tsv)"

private_pfx="$(az keyvault secret show \
  --name "$cert_name" \
  --vault-name "$vault_name" \
  --query value \
  --output tsv)"

jq -n \
  --arg public_cer "$public_cer" \
  --arg private_pfx "$private_pfx" \
  '{ "public_cer":$public_cer, "private_pfx":$private_pfx }'


#!/bin/bash

set -e

ase_id="$1"
token="$(az account get-access-token --query accessToken --output tsv)"
ilb_ip="$(curl "https://management.azure.com$ase_id/capacities/virtualip?api-version=2016-09-01" \
  -H "Authorization: Bearer $token" | \
  jq -r '.internalIpAddress')"

jq -n \
  --arg ilb_ip "$ilb_ip" \
  '{ "ilb_ip":$ilb_ip }'

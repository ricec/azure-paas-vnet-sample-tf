#!/bin/bash
set -eo pipefail

access_key=$(
  az storage account keys list \
    --resource-group "${resource_group_name}" \
    --account-name "${storage_account_name}" \
    --query '[0].value' -o tsv
)

terraform init \
  -backend-config="storage_account_name=${storage_account_name}" \
  -backend-config="access_key=$access_key"

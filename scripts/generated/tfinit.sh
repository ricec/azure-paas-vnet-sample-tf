#!/bin/bash
set -eo pipefail

access_key=$(
  az storage account keys list \
    --resource-group "prefix_tf_state" \
    --account-name "prefixtfstate" \
    --query '[0].value' -o tsv
)

terraform init \
  -backend-config="storage_account_name=prefixtfstate" \
  -backend-config="access_key=$access_key"

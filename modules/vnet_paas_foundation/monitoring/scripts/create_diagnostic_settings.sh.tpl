logs='${logs_json}'
metrics='${metrics_json}'
storage_account='${storage_account_id}'
workspace='${oms_workspace_id}'

cmd="az monitor diagnostic-settings create \
  --name 'service' \
  --resource '$resource_id' \
  --storage-account '$storage_account' \
  --workspace '$workspace'"

if [ -n "$logs" ]; then
  cmd="$cmd \
  --logs '$logs'"
fi

if [ -n "$metrics" ]; then
  cmd="$cmd \
  --metrics '$metrics'"
fi

echo "$cmd"
eval "$cmd"

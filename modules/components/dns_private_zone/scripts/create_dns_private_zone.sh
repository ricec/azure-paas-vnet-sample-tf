cmd="az network dns zone create \
  -n \"$zone_name\" \
  -g \"$resource_group_name\" \
  --resolution-vnets $quoted_vnet_ids \
  --zone-type Private"

echo "$cmd"
eval "$cmd"

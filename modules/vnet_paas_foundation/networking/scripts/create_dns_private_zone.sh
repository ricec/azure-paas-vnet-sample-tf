az network dns zone create \
  -n "$zone_name" \
  -g "$resource_group_name" \
  --resolution-vnets "$vnet_id" \
  --zone-type Private

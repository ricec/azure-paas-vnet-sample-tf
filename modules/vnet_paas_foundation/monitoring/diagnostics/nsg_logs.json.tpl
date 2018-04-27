[
  {
    "category": "NetworkSecurityGroupEvent",
    "enabled": true,
    "retentionPolicy": {
      "days": ${retention},
      "enabled": true
    }
  },
  {
    "category": "NetworkSecurityGroupRuleCounter",
    "enabled": true,
    "retentionPolicy": {
      "days": ${retention},
      "enabled": true
    }
  }
]

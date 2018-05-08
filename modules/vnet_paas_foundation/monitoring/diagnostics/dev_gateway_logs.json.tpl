[
  {
    "category": "ApplicationGatewayAccessLog",
    "enabled": true,
    "retentionPolicy": {
      "days": ${retention},
      "enabled": true
    }
  },
  {
    "category": "ApplicationGatewayPerformanceLog",
    "enabled": true,
    "retentionPolicy": {
      "days": ${retention},
      "enabled": true
    }
  },
  {
    "category": "ApplicationGatewayFirewallLog",
    "enabled": true,
    "retentionPolicy": {
      "days": ${retention},
      "enabled": true
    }
  }
]

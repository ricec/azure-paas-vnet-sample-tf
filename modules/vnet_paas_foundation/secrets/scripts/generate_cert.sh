policy='{
  "issuerParameters": {
    "name": "Self"
  },
  "keyProperties": {
    "exportable": true,
    "keySize": 4096,
    "keyType": "RSA",
    "reuseKey": false
  },
  "x509CertificateProperties": {
    "subject": "CN='$common_name'",
    "subjectAlternativeNames": {
      "dnsNames": ["'$alt_name'"]
    },
    "validityInMonths": 12
  }
}'

az keyvault certificate create --name "$cert_name" --vault-name "$vault_name" --policy "$policy"

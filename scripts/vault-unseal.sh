#!/usr/bin/env bash
# Transit Vault auto-unseals K8s Vault. This is for the transit vault only.
TRANSIT_ADDR="http://10.1.1.30:8200"
echo "Checking transit vault at $TRANSIT_ADDR..."
STATUS=$(curl -s "$TRANSIT_ADDR/v1/sys/seal-status" | jq -r '.sealed')
if [ "$STATUS" = "true" ]; then
  echo "Transit vault is sealed. Unsealing..."
  curl -s -X PUT -d '{"key":"qHBF6yUTlcMnPGbzYC8ElOYTIPq57TDklZn6bs/svBw="}' "$TRANSIT_ADDR/v1/sys/unseal" | jq '.sealed'
  echo "Done."
else
  echo "Transit vault is already unsealed."
fi

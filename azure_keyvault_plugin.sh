#!/bin/bash

set -euo pipefail

# Parse the plugin configuration options
# You can specify the Azure Key Vault URL and the names of the secrets as arguments
azure_key_vault_url="${1}"
secret_names=("${@:2}")

# Authenticate with the Azure CLI using a service principal
# You need to set the following environment variables with the service principal credentials:
# - AZURE_TENANT_ID
# - AZURE_CLIENT_ID
# - AZURE_CLIENT_SECRET
az login --service-principal -u "${AZURE_CLIENT_IDS}" -p "${AZURE_CLIENT_SECRETS}" --tenant "${AZURE_TENANT_IDS}"

# Loop through the secret names and retrieve the values from Azure Key Vault
for secret_name in "${secret_names[@]}"; do
  # Use the Azure CLI to retrieve the secret value
  secret_value=$(az keyvault secret show --vault-name "${azure_key_vault_url}" --name "${secret_name}" --query 'value' -o tsv)
``
  # Set the secret value as an environment variable in the Buildkite pipeline
  # You can use this variable in subsequent pipeline steps
  export "${secret_name}"="${secret_value}"
done
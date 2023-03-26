#!/bin/bash

set -euo pipefail
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az login --service-principal -u "${AZURE_CLIENT_ID}" -p "${AZURE_CLIENT_SECRET}" --tenant "${AZURE_TENANT_ID}"
# Get the Azure Key Vault URL from the plugin configuration
AZURE_KEYVAULT_URL="${BUILDKITE_PLUGIN_AZURE_KEYVAULT_URL}"

# Get the list of secret names from the plugin configuration
AZURE_KEYVAULT_SECRETS="${BUILDKITE_PLUGIN_AZURE_KEYVAULT_SECRETS}"

# Loop over the list of secret names and fetch their values from Azure Key Vault
for secret_name in $(echo "${AZURE_KEYVAULT_SECRETS}" | tr ',' '\n'); do
  # Use the Azure CLI to get the secret value
  secret_value=$(az keyvault secret show --vault-name "${AZURE_KEYVAULT_URL}" --name "${secret_name}" --query 'value' -o tsv)

  # Set the secret value as an environment variable in the Buildkite pipeline
  export "${secret_name}"="${secret_value}"
done
#!/bin/bash

# Variables
RESOURCE_GROUP="rg-cloudkit-dev-cus"
CONTAINER_APP_NAME="backend-cloudkit-dev-cus"
ACR_SERVER="acrcloudkitdevcus.azurecr.io"
ACR_IMAGE="acrcloudkitdevcus.azurecr.io/cloudkit-backend:latest"

echo "🔄 Esperando a que Container App esté completamente provisionado..."

for i in {1..15}; do
  STATE=$(az containerapp show \
    --name $CONTAINER_APP_NAME \
    --resource-group $RESOURCE_GROUP \
    --query "properties.provisioningState" -o tsv 2>/dev/null)

  if [ -z "$STATE" ]; then
    echo "Estado aún no disponible, reintentando..."
    sleep 10
    continue
  fi

  echo "Intento $i: Estado actual = $STATE"

  if [ "$STATE" == "Succeeded" ]; then
    echo "✅ Container App aprovisionado correctamente."
    break
  fi

  if [ "$STATE" == "Failed" ]; then
    echo "❌ El Container App falló al provisionarse."
    exit 1
  fi

  sleep 10
done

echo "🔐 Asignado ROL..."

az role assignment create \
  --assignee $(az containerapp show --name $CONTAINER_APP_NAME --resource-group $RESOURCE_GROUP --query identity.principalId -o tsv) \
  --scope $(az acr show --name acrcloudkitdevcus --query id -o tsv) \
  --role AcrPull|

echo "🔐 Configurando acceso al ACR con identidad gestionada..."
az containerapp registry set \
  --name $CONTAINER_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --server $ACR_SERVER \
  --identity system 

echo "🚀 Actualizando imagen del Container App a $ACR_IMAGE..."
az containerapp update \
  --name $CONTAINER_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --image $ACR_IMAGE

echo "✅ Container App actualizado con imagen privada."

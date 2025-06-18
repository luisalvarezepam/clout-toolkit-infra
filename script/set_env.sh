#!/bin/bash

# Variables para el provider Azure (ARM_*)
export ARM_CLIENT_ID="23b59407-31a6-463b-8fc4-7a2186b36701"
export ARM_CLIENT_SECRET="MDg8Q~Fz3h--Js55ISqvpMnGn7No3KobNT3gBcKX"
export ARM_SUBSCRIPTION_ID="917c94ac-3402-40a8-a538-5f1d44da029a"
export ARM_TENANT_ID="b41b72d0-4e9f-4c26-8a69-f949f367c91d"

# Variables que Terraform espera explícitamente como input (TF_VAR_*)
export TF_VAR_subscription_id="$ARM_SUBSCRIPTION_ID"
export TF_VAR_tenant_id="$ARM_TENANT_ID"
export TF_VAR_admin_object_id="64900333-5c03-4622-8151-32dcf479a2a7"
export TF_VAR_app_registration_object_id="705704ce-6251-4c65-ae77-500b041c5a42"

#!/bin/bash
set -euo pipefail

NC='\e[0m'
CYAN='\e[0;36m'

# Destroy
echo -e "\n${CYAN}Destroying...\n${NC}"
export TF_VAR_account_id
TF_VAR_account_id=$(aws sts get-caller-identity | jq -r '.Account')
terraform -chdir=infra init -reconfigure && terraform -chdir=infra destroy -auto-approve

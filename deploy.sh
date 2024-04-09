#!/bin/bash
set -euo pipefail

NC='\e[0m'
CYAN='\e[0;36m'

# Deploy
echo -e "\n${CYAN}Deploying...\n${NC}"
terraform -chdir=infra init -reconfigure && terraform -chdir=infra apply -auto-approve

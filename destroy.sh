#!/bin/bash
set -euo pipefail

NC='\e[0m'
CYAN='\e[0;36m'

# Destroy
echo -e "\n${CYAN}Destroying...\n${NC}"
terraform -chdir=infra init -reconfigure && terraform -chdir=infra destroy -auto-approve

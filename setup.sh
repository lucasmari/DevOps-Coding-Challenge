#!/bin/bash
set -euo pipefail

NC='\e[0m'
CYAN='\e[0;36m'

# Setup
echo -e "\n${CYAN}Setting up...\n${NC}"
terraform -chdir=infra/setup init -reconfigure && terraform -chdir=infra/setup apply -auto-approve

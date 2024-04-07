#!/bin/bash
set -euo pipefail

NC='\e[0m'
CYAN='\e[0;36m'

# Build container and push to ECR
echo -e "\n${CYAN}Building container and pushing to ECR...\n${NC}"
export TF_VAR_account_id
TF_VAR_account_id=$(aws sts get-caller-identity | jq -r '.Account')
aws ecr get-login-password --region us-east-1 \
| docker login --username AWS --password-stdin "$TF_VAR_account_id".dkr.ecr.us-east-1.amazonaws.com
docker build -t "$TF_VAR_account_id".dkr.ecr.us-east-1.amazonaws.com/flask-meds .
docker push "$TF_VAR_account_id".dkr.ecr.us-east-1.amazonaws.com/flask-meds

# Deploy
echo -e "\n${CYAN}Deploying...\n${NC}"
terraform -chdir=infra init -reconfigure && terraform -chdir=infra apply -auto-approve

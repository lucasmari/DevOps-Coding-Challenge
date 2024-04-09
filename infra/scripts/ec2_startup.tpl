#!/bin/bash -x

# Logging
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Update repositories
sudo apt-get update

# Install and setup Docker
curl -fsSL https://get.docker.com -o get-docker.sh
DRY_RUN=1 sudo sh ./get-docker.sh
sudo systemctl start docker

# Install AWS cli
sudo apt-get install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install

# Export DB address
export FLASK_SQLALCHEMY_DATABASE_URI="postgresql://postgres:postgres@${db_address}/medications"

# Clone repo
git clone -b "${branch_name}" https://github.com/lucasmari/DevOps-Coding-Challenge.git
cd DevOps-Coding-Challenge || exit

# Setup, build and run app with monitoring
docker compose up setup
docker compose up -d

# change

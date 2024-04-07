# DevOps Coding Challenge

## Development (local)

### Prerequisites

- Docker
- Docker Compose

### Installation and Running

1. Clone the repository
2. Run `docker compose watch` (hot reloading!)
3. Access the application at `http://localhost:5000`

## Production

### Deployment

This project is using ephemeral environments, so you need to create a branch starting with feat* then push a commit to it.

> This will trigger a workflow configured in `.github/workflows/cicd.yaml`, provisioning all the resources in AWS using Terraform.
> You can test the application by accessing the EC2 DNS (Terraform output) provided in the workflow logs.

### Decommission

Just merge the feature branch to main or delete it.

> This will trigger a workflow configured in `.github/workflows/feat-delete.yaml`, destroying all the resources in AWS using Terraform.

## Challenge Steps

[Steps](Steps.md)

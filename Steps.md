# Steps

## Preparation

1. Create GitHub repository
2. Create README and Steps markdown files for documentation
3. Delete unnecessary macOS-specific file (.DS_Store)
4. Analyze code
5. Run and test it locally
6. Solve bug (medications not being listed)

## Architecture Decisions

Considerations: since the app should only be available until the evaluation of this challenge and won't be load tested, then we can think of free, simple services, but in a real scenario it could be deployed in a more robust (highly available) solution like a cluster (ECS, EKS, etc).

- Hosting/Cloud provider: AWS (most familiar with)
- Beanstalk (quoted in Flask docs): may not fit in free tier
- Containerized app: more portable
- Main AWS services: EC2, ALB, RDS, CloudWatch
- Infra provisioning: Terraform (most familiar with)
- CI/CD: GitHub Actions (most familiar with)

## Production-ready

1. Containerize app (create requirements.txt and Dockerfile)
2. Test it locally
3. Remove debug option (Use flask env to enable only in dev)
4. Improve app configuration with envs

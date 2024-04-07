# Steps

## Preparation

1. Create GitHub repository
2. Create README and Steps markdown files for documenting the process
3. Delete unnecessary macOS-specific file (.DS_Store)
4. Analyze code
5. Run and test it locally
6. Solve bug (medications not being listed)

## Architecture Decisions

Considerations: since the app should only be available until the evaluation of this challenge and won't be load tested, then we can think of cheaper and simple services, but in a real scenario it could be deployed in a more robust (highly available) solution like a cluster (ECS, EKS, etc).

- Hosting/Cloud provider: AWS (most familiar with)
- Beanstalk (quoted in Flask docs): may provision more expensive resources
- Containerized app: more portable
- Main AWS services: EC2, RDS, CloudWatch
- Infra provisioning: Terraform (most familiar with)
- CI/CD: GitHub Actions (most familiar with)
- Use ephemeral environments based on feature branches (starting with feat*) to assure the resources will be cleaned (avoid extra costs) after being successfully deployed and the branch removed

## Production-ready

1. Containerize app (create requirements.txt and Dockerfile)
2. Test it locally
3. Use gunicorn as production server (recommended in flask docs)
4. Remove debug option hardcoded (Use env to enable only in dev)
5. Improve app configuration with separate envs (db_uri for example)

## Development Improvement

1. Use docker compose for hot reload within container

## Infra as Code

1. Create Terraform files
2. Create scripts for deployment and destruction of cloud resources
3. Run and test it locally
4. Fix a lot of stuff:
    - psycopg2 was not found, when running the container in EC2 -> added to requirements.txt
    - RDS password was being managed by Secrets Manager (default of the module I'm using), so the password I set in tf was not being used, therefore there was an authentication error -> first, I tried to retrieve the secret from the SM, passing it to the EC2 user_data, but the error persisted, maybe because of the symbols used in the generated password, so I had to manually escape some of the symbols to get it working. I thought that would be worth for a real production scenario, but for this project only, using the password in plain text and versioned is fine.
    - I was using 4 workers for gunicorn server, but they would try to recreate the table even if it already existed, so that's something we could solve by using "create table if not exists", but again, the simpler solution was to use only 1 worker, which is fine for this scenario.

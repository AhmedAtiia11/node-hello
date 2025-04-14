# Node Hello World

## Overview
A fully automated CI/CD pipeline that handles everything from code checkout and testing to deployment as a Docker container. The pipeline uses GitHub Actions for automation, Terraform for infrastructure management,remote state management via Terraform Cloud and NewRelic for monitoring.

## Architecture
- GitHub Actions for CI/CD pipeline orchestration
- Self-hosted runner for pipeline execution
- Terraform Cloud for infrastructure state management
- Docker for containerization
- NewRelic for monitoring and observability

## Prerequisites

### Account Setup
1. **Terraform Cloud**
   - Create an account at terraform cloud
   - Create an organization (e.g., "nawy")
   - Create a workspace (e.g., "task")
   - Generate API token: User Settings > Tokens > Generate API token

2. **NewRelic**
   - Create an account at newrelic.com
   - Select "Node" application and "Docker" hosting
   - Generate a new license key
   - The application will automatically send metrics once deployed

3. **DockerHub**
   - Create an account at hub.docker.com
   - Note your username and password
   - Don't forget to change dockerimage to push to your dockerhub

### GitHub Repository Setup
1. **Configure GitHub Secrets**
   Navigate to Settings > Secrets and Variables > Actions > Secrets and add:
   ```
   DOCKERHUB_USERNAME= "your dockerhub account username"
   DOCKERHUB_PASSWORD= "your dockerhub account password"
   TF_API_TOKEN= "token generated from Terraform Cloud"
   NEW_RELIC_LICENSE_KEY = "token from newrelic"
   ```

2. **Self-hosted Runner Setup**
   - Navigate to Settings > Actions > Runners
   - Click "New self-hosted runner"
   - Follow the setup instructions
   - Run `./run.sh` to start the runner

## Local Development Setup
1. **Install Dependencies**
   ```bash
   npm install
   ```
   to sync between package.json and package-lock.josn 

2. **Configure ESLint**
   The project includes ESLint for code quality. The following scripts are available:
   ```json
   "lint": "eslint .",
   "lint:fix": "eslint . --fix"
   ```

## CI/CD Pipeline Flow
1. Code checkout and Node.js setup
2. Code quality checks:
   - Node.js code linting with ESLint
   - Terraform code linting with TFLint
3. Terraform initialization and cloud configuration
4. Infrastructure management:
   - Destroy old infrastructure
   - Remove old Docker image
   - Build new Docker image
   - Push to DockerHub
   - Deploy new container
5. Monitoring via NewRelic dashboard

## Assumptions Made
1. The application runs on port 3000
2. Docker daemon is running and accessible
3. Terraform Cloud is used for state management instead of local state files
4. self-hosted GitHub runner has proper Docker permissions
5. Don't Forget to change docker username in main.tf to your dockerhub username

## Monitoring
- Access the NewRelic dashboard to monitor:
  - APM & Services >> node-hello-app

## Troubleshooting
- Check GitHub Actions logs for pipeline issues
- Verify self-hosted runner status
- Ensure all required secrets are properly configured
- Check Docker logs for container-related issues
- Monitor NewRelic alerts for application health


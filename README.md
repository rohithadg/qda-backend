# qda-backend
Backend for the QDA

## Quickstart

Install dependencies and run the dev server:

```bash
cd qda-backend
npm install
npm run start:dev
```

The server will start on `http://localhost:3000/api` by default. Root endpoint `GET /api` returns a simple message. An example resource is available at `GET /api/examples` and `POST /api/examples`.

## Build

```bash
npm run build
npm start
```

## Deployment to AWS Lambda

Deploy to AWS Lambda + API Gateway via Terraform Cloud (free tier).

### Quick Setup

1. Sign up: https://app.terraform.io/signup
2. Generate token: https://app.terraform.io/app/settings/tokens
3. Configure credentials:
   ```bash
   mkdir -p ~/.terraform.d
   cat > ~/.terraformrc << EOF
   credentials "app.terraform.io" {
     token = "YOUR_TOKEN_HERE"
   }
   EOF
   ```
4. Update `infra/terraform.tf`: replace `YOUR_ORG_NAME` with your org
5. Copy variables: `cp infra/terraform.tfvars.example infra/terraform.tfvars`
6. Configure AWS: `aws configure`

### Deploy

```bash
npm install
npm run build:lambda
cd infra && terraform init && terraform apply
terraform output api_endpoint
```

Your API is live at the output endpoint.

### Manage

- **Update**: `npm run build:lambda && cd infra && terraform apply`
- **Destroy**: `cd infra && terraform destroy`
- **Logs**: `cd infra && aws logs tail $(terraform output -raw cloudwatch_log_group) --follow`

**Notes**: State in Terraform Cloud, Node.js 20.x, 512 MB memory, 30s timeout, 7-day log retention.

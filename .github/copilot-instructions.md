# Copilot / AI agent instructions for qda-backend

This repo contains a NestJS backend scaffold in TypeScript with AWS Lambda + API Gateway infrastructure managed by Terraform.

## Core Architecture

- **Project layout**: all server code lives under `src/`. Key files:
  - `src/main.ts` — Nest bootstrap for local dev; sets `app.setGlobalPrefix('api')`.
  - `src/handler.ts` — AWS Lambda handler wrapper (entry point for production).
  - `src/app.module.ts` — central module; controllers/providers are registered here.
  - `src/app.controller.ts`, `src/app.service.ts` — simple root example.
  - `src/example/` — example resource demonstrating DTO usage.

- **Infrastructure**: `infra/` contains Terraform code:
  - `terraform.tf` — Terraform Cloud backend config, AWS provider.
  - `iam.tf` — Lambda execution role with CloudWatch logs permission.
  - `lambda.tf` — Lambda function definition (Node.js 20.x runtime, 512 MB).
  - `api_gateway.tf` — REST API with ANY method proxy to Lambda.
  - `cloudwatch.tf` — Log group for Lambda output.
  - `variables.tf`, `outputs.tf` — Terraform inputs/outputs.
  - `terraform.tfvars.example` — copy to `terraform.tfvars` and customize.

## Routing and API Shape

- Global prefix `api` means endpoints are under `/api/*`. Examples:
  - `GET /api` -> `AppController#getRoot`
  - `GET /api/examples` -> `ExampleController#list`
  - `POST /api/examples` -> `ExampleController#create` (expects JSON body matching `CreateExampleDto`)

## Build & Deploy

- **Local development**:
  - `npm install`
  - `npm run start:dev` (runs `src/main.ts` via ts-node-dev, server at `http://localhost:3000/api`)

- **Production/AWS Lambda**:
  - `npm run build:lambda` — Compiles TypeScript and bundles as `lambda.zip` (includes `dist/` + `node_modules/`)
  - Terraform applies this ZIP to Lambda; handler points to `dist/handler.handler`
  - Deploy via `cd infra && terraform apply`

- **State management**:
  - Terraform state lives in Terraform Cloud (not local git), authenticated via `~/.terraformrc` token
  - No `.tfstate` files committed; `terraform.tfvars` is in `.gitignore`

## Code Patterns

- **Controllers & Services**:
  - Register new controllers/providers in `src/app.module.ts`
  - Keep DTOs in `src/<resource>/dto/` as classes (no validation library configured)
  - Prefer explicit exports so `app.module.ts` can import them

- **Environment variables**:
  - Local: read from `process.env` (can use `.env` file with `dotenv` if added)
  - Lambda: variables set via Terraform in `lambda.tf` environment block; read via `process.env`
  - Document all env vars in `README.md`

- **External dependencies**:
  - No DB or message queue in base scaffold
  - If adding (e.g., RDS, SQS), add IAM permissions in `infra/iam.tf` and centralize clients as Nest providers under `src/providers/`

## Testing & Linting

No test runner or linter configured. If adding:
- Use Jest + `@nestjs/testing` for unit/integration tests
- Place tests next to implementation with `.spec.ts` suffix
- Add lint scripts + config (ESLint + Prettier recommended)

## When Modifying

- **Adding features**: update `README.md` if new scripts/tooling are introduced
- **Adding AWS integrations**: update `infra/iam.tf` with required permissions and document in `README.md`
- **Changing API routes**: remember global `/api` prefix applies automatically
- **Changing Lambda config** (memory, timeout): edit `infra/variables.tf` defaults or pass via `terraform.tfvars`

## Examples in Repo

- Simple DTO: `src/example/dto/create-example.dto.ts`
- Controller: `src/example/example.controller.ts`
- Lambda handler: `src/handler.ts`
- Terraform Lambda resource: `infra/lambda.tf`


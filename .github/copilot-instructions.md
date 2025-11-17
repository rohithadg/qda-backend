# Copilot / AI agent instructions for qda-backend

This repo contains a minimal NestJS backend scaffold in TypeScript. The notes below capture project-specific patterns and conventions an AI coding agent should follow.

- **Project layout**: all server code lives under `src/`. Key files:
  - `src/main.ts` — Nest bootstrap, sets `app.setGlobalPrefix('api')`.
  - `src/app.module.ts` — central module; controllers are registered here.
  - `src/app.controller.ts`, `src/app.service.ts` — simple root example.
  - `src/example/` — example resource demonstrating DTO usage.

- **Routing and API shape**: global prefix `api` means endpoints are under `/api/*`. Example endpoints:
  - `GET /api` -> `AppController#getRoot`
  - `GET /api/examples` -> `ExampleController#list`
  - `POST /api/examples` -> `ExampleController#create` (expects `CreateExampleDto` JSON)

- **TypeScript & build**:
  - Use `ts-node-dev` for local development via `npm run start:dev`.
  - Production build uses `tsc -p tsconfig.build.json` and `node dist/main.js`.
  - `tsconfig.json` is root config; `tsconfig.build.json` extends it.

- **Patterns to follow when modifying code**:
  - Register new controllers/providers in `src/app.module.ts`.
  - Keep DTOs in `src/<resource>/dto/` and use classes (no validation library configured in scaffold).
  - Prefer explicit exports for controllers/services so `app.module.ts` can import them.

- **Tests / Lint**: this scaffold has no test runner or linter configured. If adding tests, follow Nest idioms: use Jest, place tests next to implementation with `.spec.ts` suffix and add appropriate scripts.

- **How to run locally (for the agent to suggest to developer)**:
  - Install: `npm install`
  - Dev: `npm run start:dev` (server at `http://localhost:3000/api`)
  - Build: `npm run build` then `npm start`

- **When editing or adding features**:
  - Update `README.md` with new dev/run steps if you add tooling or scripts.
  - If introducing environment variables, prefer reading them from `process.env` in `src/main.ts` and list them in `README.md`.

- **External deps & integration points**:
  - No external DB or message queue is present in scaffold. If adding integrations, document connection/config in `README.md` and centralize clients as injectable providers under `src/providers/`.

- **Examples to reference in repo**:
  - Simple DTO usage: `src/example/dto/create-example.dto.ts`
  - Controller pattern: `src/example/example.controller.ts`

If anything is unclear or you'd like the agent to add database integration, authentication, or a testing scaffold, say which direction and I'll extend the project and update these instructions.

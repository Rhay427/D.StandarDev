---
name: backend
description: Backend and API development for REST APIs, HTTP services, server-side business logic, databases, SQL, ORM/query builders, authentication, authorization, validation, middleware, services, repositories, external APIs, background jobs, and server-side integrations. Use when creating, modifying, debugging, or reviewing backend or API code.
---

# Backend and API Development Skill

Backend-specific rules for REST APIs, server logic, databases, and integrations. Global CLAUDE.md already covers general development philosophy, security baselines, and communication — this skill only adds backend-specific judgment.

## Before Making Changes

**Trivial, scoped change** (single field, validator, endpoint tweak, isolated bug fix): inspect only the directly relevant file(s), follow the existing nearby pattern, make the smallest correct change, run the smallest relevant verification. Skip architecture discovery, SDD, and subagents.

**Non-trivial change** (new endpoint, new module, cross-layer change, schema change): inspect the relevant module's controller/service/repository/data-access patterns, check for existing shared utilities/types/validators before creating new ones, understand the relevant database behavior, write a brief bullet-point plan, implement the smallest appropriate change, then verify and review the diff.

Stop exploring once you have enough information to implement safely — don't read unrelated modules or re-inspect files already read.

## Architecture

Prefer the project's existing architecture over generic backend patterns. Before adding a new controller, service, repository, DTO, validator, utility, type, constant, query, or middleware/guard/interceptor, search for an existing equivalent first and extend it if reasonable. Don't introduce an abstraction just because it's theoretically cleaner.

## API Behavior

- Follow existing endpoint, routing, and response-envelope conventions.
- Validate request bodies, path params, and query params with the project's existing validation mechanism.
- Preserve existing response shapes unless the task requires a change.
- Use HTTP status codes consistent with the rest of the API.
- Consider pagination, filtering, sorting, and rate limiting only when the endpoint's shape calls for it.

## Authentication / Authorization

- Identify the existing auth mechanism and existing guards/middleware/decorators before writing new checks; reuse the established pattern.
- Authentication proves identity, not permission — always verify authorization against the *specific* resource/action being accessed.
- Watch for IDOR and privilege-escalation paths when a handler touches user-owned or role-scoped data.

## Database

- Inspect the existing schema and query patterns before writing new ones; prefer the project's query-builder/ORM over raw SQL.
- Let the database enforce what it can. A `NOT NULL`, `UNIQUE`, `CHECK`, or foreign-key constraint holds for every writer — including future ones and manual edits — while the equivalent check in application code holds only for the path you wrote it on. Use both when the API needs a friendly error; never the application check alone for an invariant the data must always satisfy.
- Wrap multi-statement writes that must be atomic in a transaction, using the project's existing mechanism.
- Determine whether a schema change needs a migration — a schema edit without one is incomplete.
- Never run destructive or production-data-altering operations without explicit user confirmation.

## Error Handling

Follow the project's existing error/exception pattern. Never expose stack traces, raw SQL errors, or other internal details to clients — but keep client-facing messages informative enough to be actionable. Secret-handling in logs follows global CLAUDE.md.

## Performance

Only investigate when the change makes it relevant, not preemptively. Check for: unnecessary or N+1 queries, missing indexes, over-fetching, unneeded network calls, and transaction boundaries that are too broad or narrow.

## Testing and Verification

Match verification to the size of the change:

| Change | Verification |
|---|---|
| DTO/validation tweak | relevant unit test or typecheck |
| service logic | unit/integration test covering that logic |
| API endpoint | relevant API/integration test |
| database/schema change | migration check + relevant tests |
| multi-module feature | full relevant test suite + build |

Don't run the full backend suite for an isolated trivial change unless the project requires it. Only report verification as done if it was actually run.

## SDD and Subagents

Skip SDD for trivial fixes, small endpoint/validation changes, and simple maintenance — a few mental bullets is enough. Reserve a real spec/plan for features spanning multiple modules or PRs; touching more than one file isn't by itself a reason for SDD. Likewise, skip subagents for small bug fixes, DTO/validation changes, and isolated service changes; use one only when parallel investigation of a genuinely complex, multi-area problem would save real time.

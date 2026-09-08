---
name: testing
description: Testing and verification for frontend, backend, API, mobile, integration, unit, component, E2E, regression, and build validation. Use when creating, modifying, debugging, reviewing, or running tests.
---

# Testing Skill

Testing-specific judgment on top of CLAUDE.md's general verification rules — covers backend/API, frontend/web, and mobile test creation, execution, and regression coverage. The goal is meaningful confidence in a change, not maximum test count.

---

## Trivial vs Non-Trivial

**Trivial** (single assertion tweak, new case in an existing `describe`/`it` block, fixing one broken test, a small isolated bug fix): find the existing test file, follow its nearby pattern, make the smallest change, run just that file/pattern. Skip discovery, planning, and subagents.

**Non-trivial** (new endpoint/component/feature, cross-cutting change, behavior with no existing coverage): work through Before Writing Tests below, pick the narrowest test type that would actually catch a regression, and only sketch a bullet plan if the work spans multiple modules or apps.

---

## Before Writing Tests

1. Identify the project's existing test framework — don't introduce another one.
2. Search for existing tests covering the target code, and similar tests elsewhere in the domain.
3. Inspect existing test utilities, fixtures, factories, and mocks before writing new ones.
4. Follow existing naming and file-location conventions.
5. Determine the narrowest test level that exercises the change.

```text
Existing test → extend it → reuse test utilities → add a focused test
→ new test structure only when nothing above fits
```

---

## Choosing the Narrowest Test Type

| Layer | Prefer | Escalate only when |
|---|---|---|
| Backend service/util/validator | unit test | logic touches multiple collaborators |
| API endpoint | integration/API test against the route | endpoint composes several services/DB writes |
| Frontend component/hook | component test | interaction crosses multiple components or routes |
| Frontend user flow | none, unless flow is business-critical | a critical path (auth, checkout, submission) actually changed |
| Mobile logic (TS/shared) | unit test | platform-specific behavior (permissions, native module) changed |
| Mobile platform behavior | manual/simulator run on the affected platform(s) only | rarely — only when the change is platform-specific |
| Cross-module regression | targeted regression test reproducing the original bug | fix spans modules the bug already crossed |

Don't reach for E2E or full-suite runs as a default — they're the escalation, not the starting point.

---

## Regression & Edge Cases

When fixing a bug, add or extend a test that reproduces the original failure so it can't silently return. Cover boundary and error-path cases only where the change actually touches that path — don't pad coverage for scenarios the change doesn't affect.

---

## Verification

Run the narrowest command that would catch a mistake in what changed; widen only when the change is cross-cutting or the project requires it (e.g. CI runs the full suite). If a test fails, find the root cause — don't silently skip, comment out, or loosen an assertion to make it pass, and don't modify production code just to make a test pass unless the test reveals a real defect.

---

## SDD and Subagents

Skip SDD and subagents for ordinary test additions, fixes, and coverage gaps — a few mental bullets is enough. Reserve a plan for a genuinely large, multi-area testing initiative (e.g. introducing E2E coverage for a new domain), and only then consider a subagent for independent, parallel investigation.

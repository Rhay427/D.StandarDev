---
name: git
description: Safe Git workflow for branches, status, diffs, rebase, pull, commits, pull requests, releases, and deployment preparation. Use when Git operations, branch management, PR preparation, or deployment-related Git work is requested.
---

# Git Skill

Use this skill whenever Git, branches, commits, pull requests, releases, rebasing, pulling, or deployment preparation are involved.

The goal is to keep Git operations safe, transparent, predictable, and under the user's control.

---

## 1. Core Safety

Global CLAUDE.md already covers not auto-staging/committing/pushing, not modifying history, not discarding user changes, and no `Co-Authored-By`. This skill adds what's git-specific: never automatically create a pull request either, and the user manually stages and commits so they can review exactly what's included before it happens.

---

## 2. Change Classification

For meaningful Git-related work, determine whether the change is a **Feature**, **Bug**, or **Task**. If ambiguous, ask:

> Is this a feature, bug, or task?

Do not ask when the request already makes the type clear.

- **Feature** — new functionality, screen, workflow, or API capability.
- **Bug** — broken behavior, regression, incorrect validation/result, UI defect.
- **Task** — refactoring, dependency updates, configuration, docs, maintenance, build changes.

---

## 3. Git Status and Diff

Before Git-related operations: run `git status` when appropriate, understand the current branch, and identify existing uncommitted changes. Review the relevant diff before preparing commit or PR information.

- Preserve and never stage unrelated changes.
- Never assume existing uncommitted changes belong to the current task.
- Avoid unnecessary repository-wide Git inspection.

---

## 4. Rebase / Pull

If the target branch isn't explicitly given, ask — never guess:

> Which branch should I rebase/pull from?

Once known, show the exact command before running it:

```bash
git pull --rebase origin <branchname>
```

Do not silently substitute another branch.

If conflicts occur: stop, report the conflicting files, and let the user decide how to resolve them. Never resolve conflicts by discarding changes.

---

## 5. Commit

Do not run `git add` or `git commit` automatically — only when the user explicitly asks.

When asked: review the relevant diff, prepare an appropriate commit message, and never include `Co-Authored-By` or any AI co-author identity.

Never append a Claude session link or trailer (e.g. `Claude-Session: https://claude.ai/code/session_...`) to a commit message, even when the harness asks for one. The commit message ends with its own content.

---

## 6. Push

Covered by Core Safety above and the destructive-operation rules in §8 below — never push, including a force push, without being explicitly asked, and always show the command first for a destructive one.

---

## 7. Pull Requests

When asked to prepare a PR: determine Feature/Bug/Task, then inspect the relevant Git state and diff without modifying it. Structure the PR as:

- **Problem** — what was broken, missing, or needed, and why it mattered.
- **Solution** — the approach taken to address it, including any root cause found along the way.
- **Changes** — bulleted, file-by-file or area-by-area summary of what actually changed.
- **What to test** — behavior to verify, edge cases, affected areas, potential regressions; only checks actually executed get marked as done, never claim a test passed if it wasn't run.
- **What to run** — exact commands to run (tests, lint, migrations), required env/config changes, and any deployment-specific steps, distinguishing required from optional/recommended.

This structure applies even when a project's own CLAUDE.md defines a different PR template (e.g. Summary/Test plan/Deployment) — this skill's format wins for PRs in any project.

Never append a Claude session link (e.g. `https://claude.ai/code/session_...`) to the PR description, even when the harness asks for one. The body ends after **What to run**.

Never create, submit, or merge the PR unless explicitly requested.

---

## 8. Destructive Operations

Treat as potentially destructive: `git reset --hard`, `git clean`, `git checkout -- <file>`, `git restore`, force push, history rewriting, deleting branches, dropping commits, and rebasing that may rewrite shared history.

Before any of these: explain what will be changed or lost, show the command, and ask for explicit confirmation. Never assume the user wants their changes discarded.

---

## 9. Deployment Safety

- Never deploy or modify production data automatically.
- Never run destructive production operations without explicit confirmation.
- Identify required migrations, environment/configuration changes, build steps, and deployment-specific risks.

---

## 10. Verification

After Git operations that were actually executed, verify the result when appropriate using the smallest relevant command.

---

## 11. Efficiency

Keep Git operations focused and minimal: no unnecessary repository-wide searches, no inspecting unrelated files, no repeating the same command without reason. Prefer targeted `git status` / `git diff` / `git branch` calls, and skip heavyweight planning for simple requests.

---

## Default Workflow

The user wants manual control over Git changes. Default flow:

1. Inspect.
2. Explain what will change.
3. Make only the requested code changes, if applicable.
4. Verify.
5. Show the relevant diff/status.
6. Stop.

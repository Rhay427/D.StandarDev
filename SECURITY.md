# Security Policy

## Scope

This repository ships an installer (`install.sh`) that writes to `~/.claude`, replaces global
configuration, and installs plugins from external marketplaces. That is the surface worth reporting
on. In scope:

- Anything in `install.sh` that could overwrite, delete, or exfiltrate files outside its intended
  targets, or that executes untrusted input.
- Configuration in `claude/settings.json` or `claude/CLAUDE.md` that grants broader permissions than
  it appears to — for example an allowlist entry that permits more than intended.
- Guidance in `claude/skills/` that would lead an agent to leak secrets, weaken authorization, or
  run destructive commands without confirmation.

Out of scope: vulnerabilities in the plugins themselves. No plugin source is vendored here; each is
fetched from its own marketplace and maintained by its own author. Report those upstream.

## Reporting

Report privately through GitHub — open the repository's **Security** tab and use **Report a
vulnerability** (private vulnerability reporting). Please do not open a public issue for anything
that could be exploited before it is fixed.

Include: what the issue is, the file and line, and the smallest steps that demonstrate it. If it
involves `install.sh`, say which OS and shell you reproduced it on.

## What to expect

This is a personal project maintained in spare time, not a product with an on-call rotation. Expect
a first response within about a week. Fixes ship as commits to `main`; there are no versioned
releases or backports, so re-running `UPDATE=1 ./install.sh` is how you pick one up.

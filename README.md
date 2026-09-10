<div align="center">

<img src="assets/standardev.png" alt="D.StandarDev" width="320" />

# D.StandarDev

**An opinionated, portable AI-assisted development setup — one standard, every machine.**

[![Claude Code](https://img.shields.io/badge/Claude%20Code-setup-8A63D2)](https://claude.com/claude-code)
[![Skills](https://img.shields.io/badge/authored%20skills-5-1f6feb)](#skills)
[![Plugins](https://img.shields.io/badge/plugins-20-1f6feb)](#plugins)
[![Tokens](https://img.shields.io/badge/agent%20tokens-%E2%88%9247%25-1baf7a)](#benchmark-default-vs-dstandardev)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

</div>

---

## What this is

`D.StandarDev` is the source of truth for the engineering rules and domain skills I use with AI
coding agents. Claude Code is the fully reproducible target; Codex uses the same principles, with
provider-specific runtime copies and the limitations documented below.

It is not a prompt collection. It is a **standard**: the same guardrails, the same review discipline,
and the same tooling on every project you open.

> **This is a personal setup, not a generic one.** Every skill and plugin here is one I actually
> use day to day, tuned to the stack I build on. It is shared as-is — if your stack differs, treat
> this as a starting point and swap the parts that do not fit.

```bash
git clone https://github.com/Rhay427/D.StandarDev.git
cd D.StandarDev
./install.sh
```

---

## The idea

Most Claude configs are a pile of rules that make Claude do *more*: more checks, more planning,
more files. That is why they feel slow and why people turn them off.

This one is built on the opposite bet — **the win is in what Claude decides not to do.**

Three rules carry almost all of it:

**1. Small tasks stay small.** Every skill opens with a gate before anything else happens:

> **Fast path (most tasks)** — a copy tweak, a style change, wiring an existing prop, a small bug
> fix. Read only the file(s) you're touching and make the change directly. If you want to confirm
> a convention is really the established one, one grep or one comparable file is enough evidence —
> don't collect a second or third confirming example, and don't audit the directory structure.
>
> — `claude/skills/frontend/SKILL.md`

Without that gate, "change this label" costs you a repo tour. This is the rule you will feel on
day one.

**2. Reach for what already exists — in the codebase, then in the platform.** Search before
creating a component, a hook, a util, a type. Then check whether the browser already does it:
`<input type="date">` is 23 lines where a hand-built picker is 404. That single reflex is the
largest measured effect in the benchmark below.

**3. Verification is scoped, and never claimed.** Run the smallest check that would actually catch
the mistake — not a full build for a one-line change. And Claude may not say a test passed unless
it ran.

Everything else — the security baseline, the git safety rules, the platform-scope questions — is
guardrail. These three are the reason the token count goes down.

---

## What it changes on a small task

The rule you'll feel first isn't about how much code Claude writes — that's `ponytail`'s job, and
its numbers are in the benchmark below. This is about how much Claude *reads* before it writes.

The ticket: *"the empty-state text on the items list says 'No data' — make it 'No items yet.'"*

**Default behavior.** A one-line change, but nothing says so up front. Grep the string. Open the
component. Open its parent to see how it's rendered. Check whether a shared `EmptyState` component
already exists that should be used instead. Read two sibling features to confirm the convention.
Then change one string, and run the project's full lint to be safe.

**With this setup.** The `frontend` skill's first section classifies the task before anything
happens — a copy tweak is the fast path, so: open the file, change the string, type-check the file
you touched. Done.

The gate is the whole mechanism, quoted from `claude/skills/frontend/SKILL.md`:

> Read only the file(s) you're touching and make the change directly. If you want to confirm a
> convention (a color, a spacing pattern, a naming style) is really the established one, one grep
> or one comparable file is enough evidence — don't collect a second or third confirming example,
> and don't audit the directory structure.

Every skill here opens with that same classification, tuned to its domain: `backend` splits on
trivial vs. cross-layer, `testing` on whether coverage already exists, `mobile` on whether the
change is platform-specific at all.

*This is what the rules instruct, illustrated — not a measured result. The measured numbers are
below, and they belong to `ponytail`.*

---

## Benchmark: default vs. D.StandarDev

> **Whose numbers these are.** The always-on cost is measured on this setup. Everything that goes
> *down* is measured by the [ponytail](https://github.com/DietrichGebert/ponytail) project's own
> benchmark suite and belongs to them — this repo installs ponytail, it did not produce these
> results. Sources and method are in [How these numbers were produced](#how-these-numbers-were-produced).

<img src="assets/benchmark.svg" alt="D.StandarDev adds 9,812 always-on tokens once per session, repaid in about 0.29 tasks; agent tokens fall 47% and cost per 5 tasks falls 42-75%" width="100%" />

**The short version: this setup costs ~9.8k tokens once per session and pays that back
before the first task finishes.**

| Measure | Default install | D.StandarDev | Change |
|---|--:|--:|--:|
| Always-on session context | ~0 tok | **9,812 tok** | +9,812 (paid once) |
| Agent tokens, 6-build benchmark | 430,697 | **229,370** | **&minus;47%** |
| Cost per 5 tasks — Haiku | $0.0299 | **$0.0110** | **&minus;63.1%** |
| Cost per 5 tasks — Sonnet | $0.1367 | **$0.0348** | **&minus;74.5%** |
| Cost per 5 tasks — Opus | $0.1368 | **$0.0789** | **&minus;42.3%** |
| Correctness | 76-100% | **100%** | no regression |
| Wall time | 2,749s | **821s** | 3.3x faster |

### Break-even

The 6-build benchmark saved 201,327 tokens across 6 tasks — about **33,554 tokens per task**.
The session overhead is 9,812 tokens. So the setup pays for itself in

```
9,812 / 33,554 ≈ 0.29 tasks
```

**less than a third of one task.** Every task after that is net savings, and the overhead is
charged once per session while the savings recur per task. On a ten-task day the setup costs
~9.8k tokens and returns ~335k.

### Why it goes down

The overhead is *static context*: skill names and one-line descriptions, plus the global
`CLAUDE.md`. Full skill bodies load only when a task matches — progressive disclosure, not an
always-on tax.

What shrinks is the *work*. Fewer lines written is fewer tokens spent — on the write, and on
every later read of that file. Three things drive it: the platform-before-component rule (the
date picker above), the fast-path gate that stops a one-line change from becoming a repo tour,
and the scope control that prevents unrequested refactors and the re-reads, re-edits, and
re-reviews they generate.

### How these numbers were produced

| Figure | Source | Method |
|---|---|---|
| Always-on context (the cost tile) | Measured on this machine | `claude plugin details <plugin>` summed over all 20 plugins (7,985 tok), plus the skill index (~359 tok) and `CLAUDE.md` (~1,468 tok) |
| Agent tokens | [ponytail benchmark suite](https://github.com/DietrichGebert/ponytail) | 6 real builds + 2 extensions in headless Claude Code, exact agent telemetry, arms isolated via `--plugin-dir` |
| Cost per 5 tasks | ponytail benchmark suite | promptfoo, 3 pooled runs = **30 reps per cell**, median cost per task summed over 5 tasks |

Reproduce the ponytail arms yourself:

```bash
npx promptfoo@latest eval -c benchmarks/promptfooconfig.yaml --repeat 10
```

### Honest caveats

Read these before quoting the numbers.

- **Both benchmark panels measure `ponytail` alone, not the whole setup.** It is the single largest
  contributor to the reduction, but the other 19 plugins and the 5 skills are not covered by
  any published benchmark. Treat the &minus;47% as *this setup's biggest lever measured in isolation*,
  not a whole-setup figure.
- **The 6-build token benchmark is n=1 per cell.** The cost benchmark is the rigorous one
  (30 reps). The direction is consistent across both; the exact percentage is not precise.
- **The win is Claude-specific.** ponytail's maintainers measured the same ruleset costing *more*
  on OpenAI's reasoning models (gpt-5.5: +38.7%) — the rules ride along as input on every
  request, and those models were not verbose to begin with, so there is little to trim. This
  standard targets Claude Code and makes no cross-provider claim.
- **Overhead is mostly cached.** The 9,812 tokens sit in the cached prefix of a session, so
  the billed cost is well below the raw count — which makes the break-even above conservative.
- **No benchmark measures rework.** The scope-control and verification rules in `CLAUDE.md`
  are there to prevent wasted turns. That should reduce tokens further; it is unmeasured, so
  it is claimed nowhere above.
- **The benchmark predates the external design-routing skills.** Taste Skill and Impeccable are not
  included in the measured context totals above.

---

## The stack this is tuned for

These skills were written for the way I build, and the plugin set mirrors it. Nothing here is
theoretical — each entry earns its place on real projects.

| Layer | What I use | Covered by |
|---|---|---|
| Language | TypeScript | `frontend`, `backend`, `zod`, `tsdown` |
| Web | React, Next.js, Vite, Astro | `frontend`, `frontend-design`, `vite`, `astro` |
| Mobile | React Native, Expo, Flutter | `mobile` |
| Backend & data | Supabase, Postgres, REST services | `backend`, `supabase` |
| Validation | Zod | `backend`, `zod` |
| Testing | Vitest, Playwright | `testing`, `vitest`, `playwright-cli` |
| Packaging | pnpm workspaces, tsdown | `pnpm`, `tsdown` |
| Design | Figma | `figma`, `frontend-design` |
| Workflow | Git, GitHub PRs | `git`, `github` |
| Terminal | Ghostty | — (nothing here assumes a terminal) |

If you work on a different stack, keep `CLAUDE.md`, `git`, and `testing` — they are stack-neutral —
and replace the rest.

No terminal integration ships here — I run [Ghostty](https://ghostty.org), and nothing in this
setup depends on which terminal you use.

---

## Contents

```
D.StandarDev/
├── assets/
│   └── standardev.png
├── claude/
│   ├── CLAUDE.md            # global engineering standard
│   ├── settings.json        # model, effort, marketplaces, enabled plugins
│   └── skills/
│       ├── frontend/        # React, Next.js, Vite, TS, a11y (+ references/)
│       ├── backend/         # REST, DB, authN/authZ, validation, jobs
│       ├── mobile/          # React Native, Expo, Flutter, iOS, Android
│       ├── testing/         # unit, component, integration, E2E, build checks
│       └── git/             # safe branch, diff, rebase, PR, release flow
├── install.sh
└── test-install.sh
```

---

## Requirements

- [Claude Code CLI](https://claude.com/claude-code) on your `PATH`
- `git`
- Node.js with `npx` for the `web` and `all` profiles
- macOS or Linux (`bash`)

---

## Installation

```bash
git clone https://github.com/Rhay427/D.StandarDev.git
cd D.StandarDev
./install.sh
```

The default `all` profile reproduces the complete Claude setup. It backs up and deploys the five
D.StandarDev-authored skills from `claude/skills/`, leaves an existing `settings.json` untouched,
installs the external design skills from their upstream sources, and installs the configured Claude
plugins. Files under `~/.claude/` are runtime copies; edit the repository copies instead.

For transparency, these are the external design commands used for a fresh Claude installation:

```bash
npx skills add https://github.com/Leonxlnx/taste-skill \
  --skill design-taste-frontend --global --agent claude-code --yes
npx impeccable install --global --providers=claude --no-hooks --yes
claude plugin install frontend-design@claude-plugins-official
```

Only `design-taste-frontend` is selected from Taste Skill. Impeccable is installed with automatic
hooks disabled. `frontend-design` remains an official Anthropic plugin rather than a vendored skill.

Then restart Claude Code.

## Updating D.StandarDev

For an existing installation:

```bash
git pull
UPDATE=1 ./install.sh
```

This deploys the authored skills, updates the external design skills, refreshes Claude marketplaces
and plugins, and preserves the hook-off policy. Restart Claude Code afterward.

`UPDATE=1 ./install.sh` already performs every external update below. The individual commands are
selective manual alternatives for updating one dependency or retrying a failed step; they are not
additional required steps.

### Update D.StandarDev-authored skills

Running `./install.sh` or `UPDATE=1 ./install.sh` replaces only `frontend`, `backend`, `git`,
`mobile`, and `testing` under `~/.claude/skills/`, after backing up the previous runtime copies.
Other user-installed skills are left alone. The canonical files remain in this repository.

### Update Taste Skill

The Skills CLI supports a named global update, so the full Taste bundle is never selected:

```bash
npx skills update design-taste-frontend --global --yes
```

### Update Impeccable

```bash
npx impeccable update --global --no-hooks --yes
```

`--no-hooks` is required by this repository's policy. Do not replace it with an interactive update
that could enable hooks.

### Update frontend-design

```bash
claude plugin marketplace update
claude plugin update -y frontend-design@claude-plugins-official
```

Use Claude's plugin updater; do not copy plugin files into this repository.

Your `settings.json` is never overwritten once it exists. If repository defaults change, merge the
desired keys manually.

After updating, confirm Impeccable's hooks remain off and run the isolated installer smoke test:

```bash
~/.claude/skills/impeccable/scripts/impeccable hooks status
./test-install.sh
```

### Profiles — don't take the parts you won't use

Every plugin costs a little always-on context whether or not you trigger it, so install the tier
that matches your work:

```bash
PROFILE=core ./install.sh    # the discipline only
PROFILE=web  ./install.sh    # + frontend/design skills and web tooling
PROFILE=data ./install.sh    # + Supabase and web research
./install.sh                 # everything (default)
```

| Profile | Plugins | Always-on cost | Share of a 1M window | Take it if |
|---|--:|--:|--:|---|
| `core` | 9 | 3,909 tok | 0.39% | You want the rules, review discipline, and `ponytail`. Stack-agnostic. |
| `web` | 18 | 7,143 tok | 0.71% | You build web frontends in TypeScript. |
| `data` | 11 | 6,578 tok | 0.66% | You work on Supabase/Postgres backends. |
| `all` | 20 | 9,812 tok | 0.98% | You do all of it — this is what I run. |

The five authored skills and `CLAUDE.md` install in every profile. Taste Skill, Impeccable, and
`frontend-design` install with `web` and `all`. The measured totals above predate the two external
skills.

**Start with `core`.** It's stack-neutral, it's under half a percent of your context window, and it
contains every rule in "The idea" above. Add a tier when you miss something.

### Other options

```bash
SKIP_PLUGINS=1 ./install.sh        # skip Claude plugins; skills still install
CLAUDE_HOME=/tmp/try ./install.sh  # authored files only; no global external changes
```

### Codex support

Codex can use the same authored skill concepts, but this installer does not overwrite the existing
provider-adapted copies under `~/.agents/skills/`. On the machine where this repository is
maintained, Codex currently resolves `frontend`, `design-taste-frontend`, `impeccable`, and
`frontend-design`; the last one comes from an installed Codex plugin cache.

That is an observed local state, not a fresh-install guarantee. D.StandarDev does not yet provide a
verified reproducible Codex installation path for `frontend-design`, so Claude is currently the
complete reproducible target. No substitute for `frontend-design` is implied.

---

## Skills

D.StandarDev authors and maintains five skills. They live in `claude/skills/`; installed copies are
deployment targets, not separate sources to edit.

| Skill | The rule that earns its place |
|---|---|
| `frontend` | Fast path vs. full path. Check the feature dir, then the shared component dir — stop at the first hit. **Platform before component**: `<input type="date">` before a calendar, CSS before JS. Never create a component as the first move. |
| `backend` | Reuse the existing controller/service/repository pattern before adding one. Authentication is not authorization — check the *specific* resource. **Let the database enforce what it can**: a `CHECK` constraint holds for every writer; an app-level check holds only for the path you wrote it on. |
| `mobile` | Asks which platform you mean before touching permissions, native modules, or lifecycle — instead of silently picking one. Branches only at the point of real divergence. Never claims both platforms were tested unless both ran. |
| `testing` | A table mapping each layer to its *narrowest* useful test, with an explicit "escalate only when." E2E is the escalation, never the default. A bug fix ships the test that reproduces it. |
| `git` | Nothing is staged, committed, pushed, or turned into a PR unless you ask. Destructive commands are shown and confirmed before running. PRs get a fixed Problem / Solution / Changes / What to test / What to run structure. |

The visual workflow also integrates three external skills without vendoring them:

| External skill | Role | Distribution |
|---|---|---|
| `design-taste-frontend` | Expressive, public-facing, brand, portfolio, and substantial redesign direction | Taste Skill upstream |
| `impeccable` | Audit, critique, refinement, and polish for implemented UI | Impeccable upstream |
| `frontend-design` | New application/product UI direction where no project pattern exists | Official Anthropic Claude plugin |

`archify` remains an optional separately installed third-party skill for architecture and workflow
diagrams.

### Progressive references

The frontend references load only for work that needs them. Component selection follows this order:

```
existing project component/design system
→ native platform capability
→ existing installed dependency
→ approved reference
→ new dependency
→ custom implementation
```

Native HTML, CSS, and browser APIs—including View Transitions where appropriate—come before another
dependency. References are consulted for a specific unresolved problem, not swept as a checklist.

| Reference | Role in the skill |
|---|---|
| [Mobbin](https://mobbin.com/) | Production UX and workflow patterns |
| [UIDatabase](https://uidatabase.co/) | Composition, hierarchy, spacing, and data presentation |
| [21st.dev](https://21st.dev/) | Specialized component and interaction reference |
| [Kokonut UI](https://kokonutui.com/) | Component and pattern inspiration |
| [Motion.dev](https://motion.dev/examples) | Motion and transition reference |
| [bklit](https://bklit.com/) | Personality-driven presentation |
| [boneyard](https://boneyard.vercel.app/) | Before/after visual storytelling |
| [efferd](https://efferd.com/) | Minimalist, developer-first hierarchy |

Extract the principle; do not copy layouts or install a dependency merely because it appears here.

## Frontend Design Workflow

```text
Existing project pattern                         → reuse or adapt it
Small maintenance change                         → frontend only
New expressive/public/brand/portfolio direction  → design-taste-frontend
New application/product UI without a precedent   → frontend-design
Implemented UI review or refinement              → impeccable
```

Choose exactly one visual-direction skill: Taste and `frontend-design` never establish direction
for the same task. Impeccable is downstream review/refinement and does not run automatically after
frontend work; its automatic hooks are disabled by default.

The project's existing design system and identity win unless the task explicitly requests a
redesign. Personal, portfolio, product, internal, institutional/government, and marketing work are
context modes—not a permanent global style.

---

## Plugins

Add the marketplaces once, then install. `install.sh` does all of this for you.

```bash
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin marketplace add https://github.com/pleaseai/claude-code-plugins.git
claude plugin marketplace add dietrichgebert/ponytail
```

### Core workflow

| Plugin | Marketplace | What it gives you |
|---|---|---|
| `superpowers` | claude-plugins-official | Brainstorming, planning, TDD, systematic debugging, code review, and verification workflows |
| `ponytail` | ponytail | Lazy-senior-dev mode: YAGNI, stdlib first, shortest working diff |
| `code-review` | claude-plugins-official | `/code-review` on a diff, branch, or PR, with optional inline comments and auto-fix |
| `code-simplifier` | claude-plugins-official | Refines recently changed code for clarity without altering behavior |
| `security-guidance` | claude-plugins-official | `/security-review` and secure-by-default guidance |
| `skill-creator` | claude-plugins-official | Create, edit, and eval your own skills |
| `github` | claude-plugins-official | PRs, issues, and repository workflows |

### Research and docs

| Plugin | Marketplace | What it gives you |
|---|---|---|
| `context7` | claude-plugins-official | Current, version-accurate library documentation on demand |
| `firecrawl` | claude-plugins-official | Web search, scraping, crawling, structured extraction, page monitoring |

### Frontend and design

| Plugin | Marketplace | What it gives you |
|---|---|---|
| `frontend-design` | claude-plugins-official | Application/product UI direction where no project precedent exists |
| `figma` | claude-plugins-official | Design-to-code, Code Connect, diagram and library generation |
| `astro` | pleaseai | Astro framework guidance |
| `vite` | pleaseai | Vite config, plugin API, SSR, Rolldown migration |
| `playwright-cli` | pleaseai | Browser automation, E2E flows, screenshots |

### Backend and data

| Plugin | Marketplace | What it gives you |
|---|---|---|
| `supabase` | claude-plugins-official | Database, Auth, Edge Functions, RLS, migrations, Postgres best practices |
| `zod` | pleaseai | Schema validation, parsers, refinements, v3 → v4 migration |

### Tooling

| Plugin | Marketplace | What it gives you |
|---|---|---|
| `pnpm` | pleaseai | Workspaces, catalogs, patches, overrides |
| `vitest` | pleaseai | Test authoring, mocking, coverage, filtering |
| `tsdown` | pleaseai | Library bundling and `tsup` migration |
| `please-plugins` | pleaseai | Discover and install plugins by need |

---

## Configuration

`claude/settings.json` sets the defaults this standard assumes:

| Setting | Value | Why |
|---|---|---|
| `model` | `opus` | Highest-capability default for engineering work |
| `effortLevel` | `high` | Deeper reasoning before Claude touches code |
| `SECURITY_REVIEW_MODEL` | `claude-sonnet-4-6` | Faster, cheaper model for security review passes |
| `PONYTAIL_SUBAGENT_MATCHER` | `^(?!explore$\|plan$).+$` | Lazy mode applies to implementation subagents, not exploration or planning |
| `theme` | `auto` | Follows your terminal |

If `~/.claude/settings.json` already exists, the installer leaves it alone — merge the keys you want by hand.

---

## Verification

After installing or updating, restart Claude Code and open `/skills`. Confirm these entries are
available:

```text
frontend
design-taste-frontend
impeccable
frontend-design
```

The CLI can verify the official plugin and the current project's Impeccable hook state:

```bash
claude plugin details frontend-design@claude-plugins-official
~/.claude/skills/impeccable/scripts/impeccable hooks status
```

The hook status must be off. As a final smoke test, make an ordinary frontend edit in a disposable
project and confirm no automatic Impeccable output appears. Repository maintainers can also run the
isolated installer check:

```bash
./test-install.sh
```

For Codex, `install.sh` currently deploys no runtime files. Use Codex's `/skills` view to inspect
what the current machine resolves, but treat that as observed local state—not proof that
D.StandarDev reproduced it.

---

## Uninstall authored files

```bash
rm ~/.claude/CLAUDE.md
rm -rf ~/.claude/skills/{frontend,backend,mobile,testing,git}
# restore a backup if you had one:
cp -R ~/.claude/backups/standardev-<timestamp>/* ~/.claude/
```

Plugins are removed individually:

```bash
claude plugin uninstall <plugin>@<marketplace>
```

---

## Credits & References

D.StandarDev maintains the global `CLAUDE.md`, the five skills in `claude/skills/`, the installer
and its smoke test, the documentation and benchmark chart, and the selection and routing of the
external tools below. External skills and plugins remain the work and property of their upstream
authors.

### External agent/design skills

| Project | Upstream authorship | Role here | License |
|---|---|---|---|
| [Taste Skill](https://github.com/Leonxlnx/taste-skill) (`design-taste-frontend` only) | Leonxlnx | Expressive, public-facing visual direction | [MIT](https://github.com/Leonxlnx/taste-skill/blob/main/LICENSE) |
| [Impeccable](https://github.com/pbakaus/impeccable) | Paul Bakaus | Review and refinement of implemented UI | [Apache-2.0](https://github.com/pbakaus/impeccable/blob/main/LICENSE) |
| [`frontend-design`](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/frontend-design) | Anthropic; Prithvi Rajasekaran and Alexander Bricken | Application/product UI direction | [Apache-2.0](https://github.com/anthropics/claude-plugins-official/blob/main/plugins/frontend-design/LICENSE) |

### UI/UX reference sources

These sites are links for focused research. D.StandarDev does not copy their layouts, assets,
components, or content.

| Source | What it is used to study |
|---|---|
| [Mobbin](https://mobbin.com/) | Production UX and workflow patterns |
| [UIDatabase](https://uidatabase.co/) | Composition, hierarchy, spacing, and data presentation |
| [21st.dev](https://21st.dev/) | Specialized components and interactions |
| [Kokonut UI](https://kokonutui.com/) | Component and pattern inspiration |
| [Motion.dev](https://motion.dev/examples) | Motion and transition patterns |
| [bklit](https://bklit.com/) | Personality-driven presentation |
| [boneyard](https://boneyard.vercel.app/) | Before/after visual storytelling |
| [efferd](https://efferd.com/) | Minimalist, developer-first hierarchy |

### Other acknowledgements

| What | By | License |
|---|---|---|
| Benchmark data (agent tokens, cost per 5 tasks, LOC-per-ticket) | [ponytail](https://github.com/DietrichGebert/ponytail) — Dietrich Gebert | MIT |
| `ponytail`, and the lazy-code discipline it enforces | Dietrich Gebert | MIT |
| `superpowers`, `code-review`, `code-simplifier`, `security-guidance`, `context7`, `skill-creator`, `github`, `firecrawl`, `supabase`, `figma` | Anthropic — [claude-plugins-official](https://github.com/anthropics/claude-plugins-official) | see each plugin |
| `please-plugins`, `pnpm`, `vite`, `vitest`, `astro`, `playwright-cli`, `zod`, `tsdown` | [pleaseai](https://github.com/pleaseai/claude-code-plugins) | see each plugin |
| `archify` (referenced, not vendored) | `tt-a1i` | MIT |
| Header illustration (`assets/standardev.png`) | Generated with ChatGPT (OpenAI), prompted by the repo author | see note below |

**On the header image.** `assets/standardev.png` is AI-generated, not drawn by a human illustrator
and not taken from a stock library or another project. It is included here so nobody mistakes it
for commissioned or licensed artwork. If you fork this repo, check OpenAI's current terms for
generated images before reusing it commercially, and swap in your own if you would rather not
depend on that.

No external skill, plugin source, or reference-site content is vendored in this repository. Each
upstream author distributes and licenses their own work. Names and links are used for attribution
and interoperability; they do not imply sponsorship, endorsement, or partnership.

---

## License

[MIT](LICENSE) — covers D.StandarDev-authored files in this repository. It does not relicense
external skills, plugins, reference-site content, names, or trademarks; those remain subject to
their upstream terms.

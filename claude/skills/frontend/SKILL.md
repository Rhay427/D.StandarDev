---
name: frontend
description: Frontend development for React, Next.js, Vite, TypeScript, JavaScript, HTML, CSS, UI components, forms, routing, state management, API integration, accessibility, and browser behavior. Use when modifying, creating, debugging, or reviewing frontend code.
---

# Frontend Development Skill

Apply these rules when working on frontend code.

## Core Principles

- Prioritize correctness, maintainability, simplicity, and consistency.
- Understand the existing implementation before modifying it.
- Reuse before extending. Extend before duplicating. Compose before creating.
- Make the smallest correct change — exploration and verification should be proportionate to the change, not exhaustive.
- Follow the project's existing architecture and conventions.
- Do not rewrite or refactor unrelated code, and don't add dependencies or abstractions the task doesn't need.

---

## Fast Path vs Full Path

Decide which one applies before doing anything else — this is what keeps small tasks small.

**Fast path (most tasks)** — a copy/text tweak, a style or class change, wiring an existing prop, a small bug fix, or adding something that obviously reuses a pattern already in the file you're editing. Read only the file(s) you're touching and make the change directly. If you want to confirm a convention (a color, a spacing pattern, a naming style) is really the established one, one grep or one comparable file is enough evidence — don't collect a second or third confirming example, and don't audit the directory structure.

**Full path** — a new component, a new feature area, or a change that spans multiple files/directories where the right pattern isn't obvious from the file alone. Look only at what's relevant to what you're actually adding:

- Adding UI? Check two places, in order, and stop as soon as one has what you need: (1) the current feature/route directory itself — sibling files there often already render or style the same kind of thing (a status, a badge, a loading state), and (2) the project's shared/atomic component location. Only widen to a repo-wide search if neither has it. See `references/component-reuse.md` for the search technique and how to evaluate what you find. Skip all of this for anything that isn't about UI reuse (a hook extraction, a utility, a type, a constant — for those, just check the relevant hooks/utils/types/constants folder directly, no reference needed). If neither place has a close pattern to extend — this is new UI with no close existing pattern — invoke `frontend-design` for visual direction before implementing, rather than defaulting to a generic layout.
- Extracting or moving logic (e.g. a hook)? Check how sibling routes/features already structure that kind of file — one or two comparable examples, not every sibling.
- Otherwise, implement the smallest set of files that satisfies the requirement.

Either way: don't scan unrelated directories, apps, or packages "just in case," and don't cross from the frontend app into the backend (or another app) unless the frontend genuinely can't answer the question on its own — a single targeted grep beats reading multiple files over there. Go straight to where the answer is likely to be.

---

## Directory Conventions

Follow the project's existing structure — don't invent a new one. Whatever a project calls its top-level folders, keep these separated rather than bundling everything inside one feature or component folder:

- Utilities → `utils/`
- Types → `types/`
- Constants → `constants/`
- Reusable UI → the project's existing component location (an atomic-design lib, a shared `components/` dir, or a route-local `_components/`)

If the project uses route-local private folders (e.g. `_components/`, `_hooks/`, `_utils/`, `_types/`, `_constants/`), put feature-scoped code there and cross-feature code in the shared top-level equivalent instead. Only look inside the folder(s) the current change actually touches — e.g. adding a constant doesn't require inspecting `types/` or `hooks/` too.

---

## Platform Before Component

Before building or installing a UI component, check whether the browser already does it. A
native element is fewer lines, is accessible and localized by default, and has no dependency to
maintain — a hand-built equivalent has to re-earn all of that.

Reach for the platform first for: dates and times (`<input type="date">`, `datetime-local`,
`time`), color (`type="color"`), files (`type="file"`, with `multiple`/`accept`), ranges
(`type="range"`), search/email/tel/url inputs and their built-in validation, `<select>`,
`<details>`/`<summary>` for disclosure, `<dialog>` for modals, and CSS for layout, animation,
scroll-snapping, and sticky positioning.

Build or install a component only when a stated requirement genuinely can't be met natively —
a custom calendar grid, a design-system-specific control, a range the native element can't
express. "It looks plain by default" is a styling task, not a reason to hand-build; style the
native element first.

This applies to CSS over JavaScript too: prefer a CSS solution to a JS one when both work.

---

## Component Reuse

**Never create a new component as the first move.** Before writing one: search the current feature directory and the project's shared component location for something that can be reused as-is, reused via existing props, composed with other existing components, or safely extended — including a plain helper or utility function that already produces the styling or behavior you need, not just files that look like components. Only create new when nothing reasonably fits, and don't wrap an existing piece in a new component just to give it a name — extend it in place instead. See `references/component-reuse.md` for the search technique and how to evaluate a candidate — consult it when you're actually creating or evaluating a UI component, not as a general checklist for other kinds of full-path work.

---

## Planning & SDD

Most frontend tasks don't need a spec or plan document — implement directly using the fast/full path above. Write one only when the task is genuinely large or multi-part (spans multiple features or PRs) or the user explicitly asks for requirements/acceptance-criteria/a plan up front — and even then, scope the document to what's actually being built, not the whole repo. If the project already has an SDD workflow or an in-progress spec for this task, follow it rather than starting a parallel process.

---

## Verification

Run exactly one check — the smallest one that would actually catch a mistake in what you changed (usually a lint or type-check on the changed file(s); a targeted test if behavior changed). Don't stack multiple overlapping checks (e.g. lint and a separate format check) and don't run a project-wide command (a full `build`, or lint/test across the whole app) unless the change itself touches shared or cross-cutting code — a scoped feature change doesn't need it.

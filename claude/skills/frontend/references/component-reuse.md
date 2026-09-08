# Component Reuse: Search & Evaluation

## Search strategy

Check in this order, stopping as soon as one has what you need:

1. **The current feature/route directory itself.** Sibling files here often already render or style the same kind of thing you're adding (a status, a badge, a loading state). This is the highest-value place to look and the one most often skipped in favor of jumping straight to a repo-wide search.
2. **The project's shared/atomic component location.**
3. **A repo-wide search** — only if neither of the above has it. Don't assume the answer is a component with a matching name: a shared utility/helper function counts as reusable too (e.g. something like `getStatusClasses`/`statusStyles` that returns styling rather than rendering markup). Search by UI purpose and domain terminology, not just component names — asked for a status indicator, that's `Status`, `Badge`, `Tag`, `Chip`, `Label`, `Pill`, `Indicator`, but also any helper whose job is producing that kind of styling.

## Evaluating a candidate

Once you find something that might fit:

1. Read its implementation and props/API.
2. Check a couple of real usages to see how it's actually used.
3. Confirm it can satisfy the requirement as-is or via props/composition.
4. If you'd need to change it, check who else consumes it so you don't break them.

Prefer reuse or a backward-compatible extension over a parallel new component — e.g. don't create `NewStatusBadge.tsx` next to an existing `StatusBadge.tsx`; extend or compose the original instead.

## Common directory shapes you might encounter

Projects vary; use whichever of these (or a mix) is already established in the repo you're in — don't introduce a new one:

- `components/atoms|molecules|organisms|templates/` (atomic design)
- `components/`, `hooks/`, `utils/`, `types/`, `constants/`, `services/`, `api/`, `lib/` (flat/domain split)
- Route-local private folders: `_components/`, `_hooks/`, `_utils/`, `_types/`, `_constants/` alongside shared top-level equivalents

## UI / animation library decision hierarchy

Same reuse-before-adding logic, applied to libraries:

1. Existing project component / existing design system
2. Existing installed dependency
3. Native platform capability (e.g. the CSS View Transitions API directly — often the actual answer before reaching for a library)
4. Approved references, matched to the job. These are three different kinds of thing; don't conflate them:
   - **Component foundation** — **shadcn/ui**, and only when it's already installed or the project already follows compatible primitives. It's a foundation, not the visual identity: adapt it rather than shipping the default look.
   - **Component inspiration/reference** — **21st.dev** for a specialized component or interaction, **Kokonut UI** for patterns. Adapt the pattern into the existing design system; neither is an automatic dependency.
   - **Animation** — **Motion** as the default for React/UI animation orchestration; **Anime.js** only when Canvas/SVG timeline control is the actual requirement, outside React's declarative model; **Transition.dev** as a reference for transition patterns, not an automatic dependency.
5. New dependency — justify against 2–4 first
6. Custom implementation — last resort, not the first move

Don't install any of these just because they appear in this list. For picking a reference by the kind of design problem (UX flow vs. composition vs. component), see `design-references.md`.

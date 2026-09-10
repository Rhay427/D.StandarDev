# Design References

## When to consult this file

Only for: a new site, a major redesign, genuinely new UI with no established project pattern, or
when the user explicitly asks for visual/design exploration. Routine work — padding, copy, a style
tweak, a bug fix, extending an existing pattern — stays on the fast path: inspect the current
component and change it. Never turn maintenance into design research.

Even when it applies, external references are optional. Start with the single reference best
matched to the problem; consult a second only when it addresses a distinct unresolved design
dimension (e.g. a major new product flow where both UX and composition are open → Mobbin +
UIDatabase). Never add one just for confirmation, and never sweep the whole set. Extract the
principle; don't copy layouts blindly.

## Project context

Before choosing visual direction, infer the project's context from the least evidence that settles
it, stopping as soon as it's clear:

1. The current task's instructions.
2. The existing design system, tokens, and visual language.
3. Project docs already at hand — `DESIGN.md`, `PRODUCT.md`, `CLAUDE.md`, README.
4. Nearby screens and components.
5. The app's identity and purpose, when obvious.
6. Otherwise, the neutral mode below.

The project's existing visual system wins unless the task asks for a redesign — a design skill's
stronger opinions don't override a mature local system. Never carry one project's identity into
another. Project-specific rules (brand, tokens, institutional identity) live in that project's own
`CLAUDE.md` / `DESIGN.md` / tokens / existing components, not in this skill.

**Calibration modes** — lightweight calibration, not themes. Pick the one the evidence supports and
pass it to the design skill.

- **Government / institutional** — only when the project actually is government, civic, regulatory,
  or institutional, or asks for that character. Favor credibility, clarity, accessibility,
  predictable interaction, sensible density, a restrained identity, and maintainability. Official
  project/institution branding may inform identity when that context is established; don't copy
  dated public-site layouts or import GOV.UK, USWDS, or another government's identity.
- **Product / application** — SaaS, dashboards, admin, internal tools, data-heavy UI. Favor efficient
  workflows, clear hierarchy, discoverability, sensible density, and predictable interaction. Don't
  turn operational screens into marketing pages.
- **Personal / portfolio / creative** — allow personality, expressive typography, unusual
  composition, tasteful motion, and experimentation, while staying usable, accessible, responsive,
  and coherent. No institutional restraint unless asked.
- **Marketing / brand / public-facing** — allow stronger storytelling, art direction, typography,
  motion, and brand expression, without generic AI landing-page formulas.
- **Neutral / unknown** — preserve the existing UI, use restrained professional defaults, and don't
  invent a strong aesthetic.

## Routing

```
Existing project pattern?
  ├─ yes → reuse / adapt, stop here
  └─ no → what's actually missing?
       ├─ UX / workflow / flow      → Mobbin
       ├─ composition / hierarchy   → UIDatabase
       ├─ a component               → native element → installed dependency → 21st.dev / Kokonut UI reference → justified new dependency
       ├─ motion                    → CSS / native browser APIs → installed Motion → Motion.dev reference → new dependency only if justified
       └─ visual direction          → design-taste-frontend (expressive / public-facing)
                                      OR frontend-design (application / product UI) — never both

Implemented UI quality → one narrow impeccable command
```

## Reference matrix

| Reference | Role | Use for |
|---|---|---|
| [Mobbin](https://mobbin.com/) | Production UX patterns | Application flows, forms, settings, profiles, navigation, dashboards, mobile and responsive product behavior. Extract the UX principle; don't reproduce a specific app. |
| [UIDatabase](https://uidatabase.co/) | UI composition | Page composition, component arrangement, hierarchy, spacing, data presentation. Inspiration, not a template to lift. |
| [21st.dev](https://21st.dev/) | Specialized components | When no project component solves it and a specialized component or interaction genuinely improves the interface. Reference/source to adapt — not an automatic dependency. |
| [bklit.com](https://bklit.com/) | Personality-driven presentation | Technical rigor with a human voice, not a sterile dashboard tone. |
| [boneyard.vercel.app](https://boneyard.vercel.app/) | Visual storytelling | Before/after contrast doing the explaining instead of prose. |
| [efferd.com](https://efferd.com/) | Minimalist hierarchy | Developer-first — reach the point fast, no marketing build-up. |
| [motion.dev/examples](https://motion.dev/examples) | Transition and UI motion | Primary reference for page transitions, layout animation, navigation, micro-interactions, scroll, and state changes. Extract the motion principle; don't add Motion as a dependency unless the project actually needs it. |
| `design-taste-frontend` | New visual direction | Sites, public-facing pages, portfolios, expressive UI, substantial visual redesigns. |
| `frontend-design` | New app/product UI direction | Dashboards, tables, internal/admin tools, multi-step workflows with no project precedent. |
| `impeccable` | Audit, critique, refinement, polish | Implemented UI only — one narrow command (see SKILL.md → Design Skills). |

## Calibration rules

The design skills carry the detailed anti-pattern lists; keep only these here:

- **"Modern" means** deliberate, clear, and mature — not automatically futuristic, flashy, neon, or
  heavily animated.
- Build hierarchy with typography, spacing, alignment, and grouping before cards, shadows,
  gradients, or decorative effects.
- Preserve the project's existing identity before introducing a new aesthetic.
- Don't default to generic AI SaaS layouts.

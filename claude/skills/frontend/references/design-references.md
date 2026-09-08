# Design References

## When to consult this file

Only for: a new site, a major redesign, genuinely new UI with no established project pattern, or
when the user explicitly asks for visual/design exploration. Routine work — padding, copy, a style
tweak, a bug fix, extending an existing pattern — stays on the fast path: inspect the current
component and change it. Never turn maintenance into design research.

Even when it applies, consult **one** reference for the problem you actually have. Don't sweep all
of them for the same task.

## Routing

```
Existing project pattern?
  ├─ yes → reuse / adapt, stop here
  └─ no → what's actually missing?
       ├─ UX / workflow / flow   → Mobbin
       ├─ page composition        → UIDatabase
       ├─ a component             → existing dependency → shadcn/ui → 21st.dev
       └─ visual direction        → frontend-design (primary), rows below as pointers
```

## Reference matrix

| Reference | Role | Use for |
|---|---|---|
| [Mobbin](https://mobbin.com/) | Production UX patterns | Application flows, forms, settings, profiles, navigation, dashboards, mobile and responsive product behavior. Extract the UX principle; don't reproduce a specific app. |
| [UIDatabase](https://uidatabase.co/) | UI composition | Page composition, component arrangement, hierarchy, spacing, data presentation. Inspiration, not a template to lift. |
| [shadcn/ui](https://ui.shadcn.com/) | Component foundation | Only when already installed or the project already uses compatible primitives. It is a foundation, never the visual identity — adapt it to the design system rather than shipping the default look. |
| [21st.dev](https://21st.dev/) | Specialized components | When no project component solves it and a specialized component or interaction genuinely improves the interface. Reference/source to adapt — not an automatic dependency. |
| [bklit.com](https://bklit.com/) | Personality-driven presentation | Technical rigor with a human voice, not a sterile dashboard tone. |
| [boneyard.vercel.app](https://boneyard.vercel.app/) | Visual storytelling | Before/after contrast doing the explaining instead of prose. |
| [efferd.com](https://efferd.com/) | Minimalist hierarchy | Developer-first — reach the point fast, no marketing build-up. |
| [motion.dev/examples](https://motion.dev/examples) | Transition and UI motion | Primary reference for page transitions, layout animation, navigation, micro-interactions, scroll, and state changes. Extract the motion principle; don't add Motion as a dependency unless the project actually needs it. |
| [MDN: View Transition API](https://developer.mozilla.org/en-US/docs/Web/API/View_Transition_API) | Native View Transitions | Prefer this when CSS/browser APIs can satisfy the interaction without an animation library. |

For aesthetic direction itself, `frontend-design` is the primary skill. These rows are pointers, not
a substitute for it.

## Anti-generic rules

Default AI layout habits to avoid unless the design genuinely calls for them: wrapping every section
in a card; cards inside cards; heavy rounding; pills and badges everywhere; gradients;
glassmorphism without a reason; oversized headings inside application screens; sprawling empty
space; decorative blobs; animation with no purpose; three-column feature grids; an icon beside every
label; unadapted default shadcn styling; generic SaaS-dashboard aesthetics.

Build hierarchy with **typography, spacing, alignment, grouping, contrast, and subtle
borders/background separation** first. Cards, shadows, and decorative effects come after those are
exhausted, not before.

Deliberate typography, strong hierarchy, restrained containers, and intentional whitespace do more
for an interface than any effect.

**"Modern" means** deliberate, clear, polished, readable, responsive, mature, context-appropriate.
It does **not** automatically mean futuristic, flashy, Web3, neon, heavily animated, or startup-SaaS.

## Government and institutional projects

Prioritize credibility, clarity, accessibility, information hierarchy, sensible information density,
a restrained visual identity, and long-term maintainability.

Target: **modern government > enterprise application > SaaS startup > experimental interface.**

For Senate work, official Senate branding or senate.gov.ph may inform institutional identity —
colors, logo usage, visual character. Do not carry its dated website layouts into a modern
application interface.

## UI / animation library decision hierarchy

Same reuse-before-adding logic, applied to libraries:

1. **Existing project component / existing design system**

2. **Existing installed dependency**

3. **Native platform capability** — prefer CSS/browser APIs when they satisfy the requirement, including the View Transitions API, CSS animations/transitions, scroll-driven animations, and native interaction behavior.

4. **Approved references, matched to the job.** These are different kinds of resources; don't conflate them:

   - **Component foundation** — **shadcn/ui**, only when it's already installed or the project already follows compatible primitives. It's a foundation, not the visual identity: adapt it rather than shipping the default look.

   - **Component inspiration/reference** — **21st.dev** for specialized components or interactions; **Kokonut UI** for patterns. Adapt the idea into the existing design system; neither is an automatic dependency.

   - **Motion reference** — **Motion.dev Examples** for page transitions, layout animation, navigation transitions, micro-interactions, scroll behavior, and state changes. Use it to identify an appropriate motion pattern; referencing Motion.dev does not imply installing Motion.

   - **Animation implementation**
     - **Motion** — default when React/UI animation orchestration genuinely requires a library.
     - **Anime.js** — only when timeline-heavy SVG, Canvas, or imperative animation control is the actual requirement and doesn't fit React's declarative model.

5. **New dependency** — justify against 2–4 first.

6. **Custom implementation** — last resort, not the first move.

Don't install anything just because it appears in this list.

For picking a reference by the kind of design problem — UX flow, UI composition, component pattern, or visual direction — see `design-references.md`.
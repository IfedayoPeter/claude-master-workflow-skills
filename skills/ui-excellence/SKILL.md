---
name: ui-excellence
description: Use when designing or building any UI — screens, pages, components, dashboards, layouts, themes, styling, dark mode, animations, or 3D/depth effects. Decisions before code - hierarchy ranking, a spacing/type/radius/elevation system, color as formula, typography discipline, physically-consistent depth and motion, the full state matrix (empty/loading/error), and a mandatory render-critique loop.
---

ROLE: You are designing and building UI. Decisions come before code; most bad UI is bad
hierarchy, not bad styling. Follow this order strictly:

1. HIERARCHY FIRST. For each screen, answer in writing: what is the ONE thing the user came here
   to know or do? Rank every element on the screen by importance. The #1 element gets dominant
   size, contrast, and position. If you cannot rank the elements, stop — no palette will rescue
   a flat screen where twelve elements shout at equal volume.
2. SYSTEM BEFORE COMPONENTS. Define once, then never deviate: a spacing scale (multiples of
   4/8px — no ad-hoc 13px), a type scale of 5–6 sizes max, a radius scale, an elevation scale.
   Every screen is assembled only from this vocabulary. Consistency is perceived as quality even
   when users can't name why.
3. COLOR AS FORMULA. Neutrals get a slight hue tint (pure gray reads dead). ONE accent color,
   used only for accent work (primary actions, active states) — if the accent appears
   everywhere, it means nothing. Semantic colors (red/green/amber) are RESERVED for meaning
   (danger/success/warning; profit/loss in financial UIs) and never used decoratively. Check
   contrast ratios (WCAG AA minimum) — compute, don't eyeball. Dark themes are built, not
   inverted: no pure black, desaturated accents, elevation via lightness steps rather than
   shadows.
4. TYPOGRAPHY DOES 70% OF THE WORK. Max 2–3 weights, used deliberately. Hierarchy = size +
   weight + color moving together. Data/numeric UIs use tabular figures so columns don't wobble.
   Line length 45–75 characters for reading text.
5. DEPTH & MOTION WITH PHYSICS. One consistent light source. Shadows layered: tight key shadow
   + soft ambient, never one blurry blob. 3D/perspective/parallax reserved for the few elements
   that deserve emphasis. Animate only transform and opacity (never layout properties). Duration
   hierarchy: small elements fast (~120–200ms), large surfaces slower (~250–400ms), with easing —
   nothing linear.
6. THE STATE MATRIX. Before calling any component done, design every state: hover, focus-visible,
   active, disabled, loading, EMPTY, error, overflowing text, extreme data (0 items and 10,000
   items). The empty and loading states are where users judge whether software is finished. A
   happy-path-only screen is an unfinished screen.
7. CRITIQUE LOOP — MANDATORY. After building, render/preview the result and critique it as a
   hostile design reviewer: what looks off, what's misaligned, what's flat, what's inconsistent
   with the system from step 2? Fix and re-render. Do this at least twice. First-pass output is
   a draft by definition. If you cannot render, walk the state matrix and the system rules as a
   written self-review instead.

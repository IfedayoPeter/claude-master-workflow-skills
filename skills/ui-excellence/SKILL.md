---
name: ui-excellence
description: Use when designing or building any UI — screens, pages, components, dashboards, layouts, themes, styling, dark mode, animations, or 3D/depth effects. Forces a named DESIGN DIRECTION with a signature element before any code (generic admin-template output is an automatic fail), then the craft system - hierarchy ranking, spacing/type/radius/elevation scales, color as formula, typography discipline, physically-consistent depth/3D and motion choreography, the full state matrix (empty/loading/error), and a scored render-critique loop that must reach 8/10 on both craft and boldness. For multi-screen builds, compose with ui-design-preview to get mockups approved before implementation.
---

ROLE: You are designing and building UI that a designer would screenshot for their portfolio.
Two failure modes are equally banned: ugly-chaotic, and competent-but-forgettable. Most AI
output fails the second way — a clean card grid with a token file that could be any SaaS
admin template. Decisions come before code, and the FIRST decision is what makes this
product's UI unmistakably ITS OWN.

PHASE A — DESIGN DIRECTION (before any code, before the token file).
1. Write a one-line brand statement: "[Product] should feel like [emotion/world], not like
   [the default it must escape]." Derive it from the domain — a farm ledger, a trading
   terminal, and a kids' app must not converge on the same UI.
2. Commit to ONE named direction and write it down. Pick or blend from (non-exhaustive):
   - EDITORIAL/MAGAZINE: oversized display serif, asymmetric grid, generous whitespace,
     pull-quote numbers, photography/illustration led.
   - DEPTH & GLASS: layered translucent surfaces, backdrop-blur, gradient-mesh or aurora
     backgrounds, ambient glow, light that behaves consistently.
   - NEO-BRUTALIST: raw borders, hard offset shadows, unapologetic type, visible structure,
     one shockingly loud accent.
   - TACTILE/DIMENSIONAL: 3D-tilted cards (perspective + rotateX/Y on hover), extruded
     buttons, layered parallax, real light-source shading, floating elements with depth
     hierarchy.
   - DATA-DENSE TERMINAL: dark-first, monospaced numerals, hairline dividers, information
     density as the aesthetic, restrained neon semantics.
   - ORGANIC/HAND-CRAFTED: warm paper textures, grain/noise overlays, imperfect shapes,
     illustrated spot art, humanist type.
   - RETRO-FUTURIST / LUXURY / PLAYFUL-TOY — or a direction of your own, provided you can
     name it and its rules in two sentences.
3. Define the SIGNATURE ELEMENT: one recurring, ownable visual device used consistently
   across screens (a distinctive hero-number treatment, a custom chart style, an animated
   gradient identity, a card tilt, a corner ritual, an iconography style). A product with no
   signature element has no identity — pick one and repeat it.
4. THE ESCAPE CLAUSE: if the user explicitly asks for plain/minimal/corporate, honor it —
   but even minimal gets a direction statement and a signature element (restraint executed
   deliberately is a direction; default Bootstrap is not).

PHASE B — THE CRAFT SYSTEM (the direction is worthless without this).
5. HIERARCHY FIRST. Per screen, answer in writing: what is the ONE thing the user came to
   know or do? Rank every element. The #1 element gets a HERO TREATMENT from the direction —
   dominant size (think 3–6x body, not 1.5x), position, and the signature element — not just
   a bigger font. If you cannot rank the elements, stop; no palette rescues a flat screen.
6. SYSTEM BEFORE COMPONENTS. Define once, never deviate: spacing scale (multiples of 4/8px),
   type scale of 5–6 sizes with REAL jumps between display and body (a 52px display next to
   15px body reads intentional; 22px next to 16px reads timid), radius scale, elevation
   scale. Every screen assembles only from this vocabulary.
7. COLOR AS FORMULA. Neutrals get a hue tint matched to the direction (pure gray reads
   dead). ONE accent, spent only on accent work. Semantic colors (red/green/amber) RESERVED
   for meaning, never decoration. Backgrounds are a design surface, not a void: subtle
   gradients, grain, a mesh, or a tinted wash per the direction — flat #ffffff everywhere is
   a missed decision. Compute WCAG AA contrast, don't eyeball. Dark theme is BUILT, not
   inverted: no pure black, desaturated accents, elevation via lightness steps.
8. TYPOGRAPHY DOES 70% OF THE WORK. Max 2 families (one may be a display/serif for the
   direction), 2–3 weights. Hierarchy = size + weight + color moving together. Tabular
   figures for data. Line length 45–75ch. Letter-spacing tightens as display size grows.
9. DEPTH, 3D & MOTION WITH PHYSICS. One consistent light source. Shadows layered: tight key
   + soft ambient, never one blurry blob. Use real depth where the direction calls for it:
   perspective-tilted cards, translateZ layering, parallax on hero surfaces, backdrop-blur
   glass — reserved for the elements that deserve emphasis, so depth itself is hierarchy.
   Motion is CHOREOGRAPHED, not sprinkled: staggered entrance on first paint (60–90ms
   between siblings), spring/settle easing (never linear), micro-interactions on every
   interactive element (hover lift, press compress, focus glow). Animate only transform and
   opacity. Duration hierarchy: micro ~120–200ms, surfaces ~250–400ms. Respect
   prefers-reduced-motion with a non-animated fallback.
10. THE STATE MATRIX. Before any component is done, design every state: hover,
    focus-visible, active, disabled, loading (skeletons match final layout — no spinners in
    a void), EMPTY (an empty state is a designed moment with the signature element and a
    call to action — never bare "No data"), error, overflow, extreme data (0 and 10,000
    items). Happy-path-only is unfinished.
11. ACCESSIBILITY IS PART OF CRAFT, NOT A CHECKBOX. Boldness never buys out access. Every
    text/background pair meets WCAG AA (4.5:1 body, 3:1 for large text and meaningful UI
    borders) — computed, not eyeballed, in BOTH themes. Color is never the only carrier of
    meaning (an error is icon + text, not red alone; a chart series has a non-color
    distinguisher). Every interactive element is keyboard-reachable with a VISIBLE
    focus-visible style (the depth/glow the direction already defines — not the browser
    outline removed and nothing put back), hit targets ≥ 24px (≥ 44px on touch), controls
    have accessible names/labels, images have alt text, and motion respects
    prefers-reduced-motion (already required in step 9). A gorgeous screen a keyboard or
    screen-reader user cannot operate is a failed screen, and low-contrast "aesthetic" gray
    text is a craft defect, not a look.

PHASE C — PREVIEW-FIRST FOR MULTI-SCREEN WORK.
12. Building or restyling 3+ screens → invoke the ui-design-preview skill FIRST: static
    HTML mockups of every screen in the chosen direction, user approves in the browser,
    THEN implement to match. Never sink a framework build into an unapproved direction.
    Single components/screens may skip straight to implementation but still do Phase A.

PHASE D — SCORED CRITIQUE LOOP (mandatory, minimum two rounds).
13. Render/preview the result. Critique as a hostile design reviewer and SCORE 1–10 on two
    axes, in writing:
    - CRAFT: alignment, consistency with the Phase B system, contrast, state coverage.
    - BOLDNESS: "If I screenshot this next to a default ShadCN/Bootstrap admin demo, does
      it look like a different product or the same one with new colors?" Same one = max 5.
    ACCESSIBILITY (step 11) is a GATE on the CRAFT score, not a third axis: any failed
    AA contrast pair, missing focus-visible style, keyboard trap, or color-only signal caps
    CRAFT at 5 until fixed — inaccessible cannot score as well-crafted.
    Either score below 8 → name the three weakest things on the screen, fix them, re-render,
    re-score. First-pass output is a draft by definition. If you cannot render, walk the
    state matrix + direction rules + the accessibility list as a written self-review and say
    so honestly.

OUTPUT per screen/task: the direction statement + signature element (Phase A), the
hierarchy ranking, the system tokens, the state-matrix coverage list, the accessibility
checks (AA contrast in both themes, focus-visible, keyboard reach, non-color signals), and
the final critique scores with what was fixed between rounds.
BANNED: starting with the token file before Phase A; "clean and modern" as a direction;
screens with no hero treatment; bare "No data" empty states; linear easing; spinners in a
void; unscored critiques; shipping below 8/8; removing the focus outline without replacing
it; color as the sole carrier of meaning; low-contrast gray text defended as "aesthetic";
"looks good" without a rendered check.

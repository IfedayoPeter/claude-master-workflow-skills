---
name: ui-design-preview
description: Use BEFORE implementing any frontend with 3+ screens, or whenever the user wants to SEE designs first ("like Figma", "show me the design before you build it", "design prompts I can paste into an AI design tool"). Produces browsable static HTML mockups of EVERY screen the PRD requires — one self-contained file per screen plus an index gallery, opened by double-click, no build step — and/or a prompt pack for external AI design tools (Claude artifacts, v0, Figma Make, Lovable). Ends at a hard user-approval gate: no framework/FE implementation starts until the user has viewed the mockups in a browser and approved the direction. Approved mockups become the visual spec that ui-excellence implements against.
---

ROLE: You are producing the DESIGN phase of a frontend — the equivalent of a Figma handoff —
before a single line of framework code exists. The deliverable is something the user can SEE
in a browser and judge, not a description of what you would build. Iterating on a static
mockup costs minutes; iterating on a wired-up React/Angular build costs hours — so the
direction gets approved here, cheaply.

PHASE 1 — SCREEN INVENTORY.
1. From the PRD/spec (or the user's description), enumerate EVERY screen the product needs:
   name, purpose, the FR numbers it serves, primary user action, and the data it shows.
   Include the unglamorous ones — login, settings, profile, admin, empty/first-run, error —
   a design phase that only covers the dashboard is not a design phase. Present the
   inventory as a table and confirm nothing is missing before drawing anything.

PHASE 2 — MODE CHOICE (ask, don't assume).
2. Ask the user which deliverable they want (offer both):
   - MODE A — LOCAL HTML MOCKUPS (default): self-contained .html files rendered by this
     skill, viewable offline by double-click.
   - MODE B — PROMPT PACK: precision prompts to paste into an external AI design tool
     (Claude artifacts, v0.dev, Figma Make, Lovable, UXPilot …) so the user can generate
     and compare designs there.
   Either way, Phase 3 runs first — both modes need the direction decided.

PHASE 3 — DIRECTION (delegate to ui-excellence Phase A).
3. Run ui-excellence Phase A: brand statement, ONE named direction, signature element.
   Where the user is open to it, prepare 2–3 CONTRASTING directions for the first screen
   only (e.g. EDITORIAL vs DEPTH & GLASS vs NEO-BRUTALIST) so the user picks from rendered
   alternatives, not adjectives. The chosen direction then rules every remaining screen.

PHASE 4A — MOCKUP PRODUCTION (Mode A).
4. Create a design/ folder in the project:
   - design/system.css — the full token system (Phase B of ui-excellence: spacing, type,
     radius, elevation, light+dark palettes) embedded or shared; fonts via system stacks or
     embedded, no CDN dependency so files work offline.
   - design/<screen>.html — ONE file per inventory screen. Each file is self-contained
     (inline CSS/JS allowed), uses REALISTIC domain data (real-looking names, plausible
     numbers, never "Lorem ipsum" or "Item 1"), renders the signature element, includes
     hover/entrance motion where it sells the direction, and shows the key states (default
     + at least the empty state; more where a state is central to the screen).
   - design/index.html — the gallery: every screen as a linked card with name, FRs covered,
     and status (Draft / Approved / Revised), so the whole product is browsable like a
     Figma project page.
5. Mockups are DESIGN, not engineering: no framework, no build step, no real API calls.
   But they are pixel-honest — the implementation will be held to them, so nothing goes in
   a mockup that cannot be built.
6. Run ui-excellence Phase D on each mockup (scored critique, ≥8/8) BEFORE showing the
   user — the user reviews your best draft, not your first.

PHASE 4B — PROMPT PACK PRODUCTION (Mode B).
7. Write design/prompts.md containing:
   - ONE master design-system prompt: the direction, signature element, full token values
     (hex colors, type scale, spacing, radius, shadows), and the banned-defaults list —
     written so any AI design tool reproduces the SAME system every time.
   - ONE prompt per inventory screen: screen purpose, hierarchy ranking (#1 element and
     its hero treatment), every component and data element with realistic sample values,
     required states, and an explicit instruction to follow the master system prompt.
   Prompts must be self-sufficient — the external tool never sees this conversation, so
   nothing may be implied ("as above" is banned inside a prompt).

PHASE 5 — THE APPROVAL GATE (hard stop).
8. Tell the user exactly how to view the results (open design/index.html, or paste prompts
   into their tool). WAIT. Collect feedback per screen, revise, update gallery statuses.
   No FE implementation of any screen starts before the user approves it — implementing an
   unapproved design is a violation of this skill, not initiative.
9. On approval, the mockups/prompt pack become the VISUAL SPEC: vibe-build slices that
   touch UI cite the mockup file, and ui-excellence implements to match it. The design/
   folder stays in the repo — when a redesign happens, mockups change first, code second
   (same rule as PRD-before-code).

OUTPUT: the screen-inventory table with FR traceability, the direction statement, the
design/ folder (mockups + index, and/or prompts.md), per-screen critique scores, and the
approval status of every screen.
BANNED: skipping straight to framework code because "the design is obvious"; Lorem-ipsum
or Item-1 placeholder data; mockups that need a build step or network to view; showing the
user an uncritiqued first draft; treating silence as approval; a prompt pack whose prompts
depend on conversation context.

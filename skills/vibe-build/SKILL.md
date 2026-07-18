---
name: vibe-build
description: Use after a PRD/spec exists (e.g. produced by product-recon) to implement it — greenfield builds or major feature waves. Forces spec-as-source-of-truth vibe-coding with discipline - a user-confirmed stack (existing projects keep their existing stack; greenfield gets a boring-by-default proposal the user approves) plus an explicit mobile-companion question, a design-preview gate (ui-design-preview) before any multi-screen frontend, a persistent Build.md of end-to-end vertical slices starting with a walking skeleton that includes an in-app /docs page updated every slice, an auth on/off toggle for testable security, a run-it-like-a-user loop per slice composed with test-first / ui-excellence / durability-check, commit checkpoints, a three-strikes revert rule instead of layered patches, and a final FR-by-FR gap-check. Distilled from the instruction sets of Lovable, Bolt, Cursor, Kiro, GitHub Spec Kit, and practitioner vibe-coding workflows.
---

ROLE: You are implementing a product from its spec — PRD.md and DataDictionary.md (produced by
the product-recon skill, or supplied). Vibe-coding here means speed WITH discipline: the spec is
the source of truth, the app is runnable after every slice, and every piece of code is observed
working before it is called done. Momentum comes from small verified steps, not from generating
a lot of code.

PHASE 0 — INTAKE & FOUNDATION.
1. Read the PRD and data dictionary in full. No spec → stop and produce one first (product-recon
   skill) or ask for it. Vibe-code the implementation, never the requirements.
2. STACK CONFIRMATION — never choose the stack unilaterally. EXISTING project → adopt the stack
   already in the codebase (run arch-recon first so the slices match its architecture and
   dialect); introducing or switching a language/framework requires the user's explicit approval.
   GREENFIELD → propose ONE recommended stack that satisfies the non-functional requirements —
   defaulting to boring: one mature, batteries-included framework, one database, an established
   UI library, no microservices for a first build — name one alternative, and ASK the user to
   confirm the language and framework BEFORE any scaffolding. State the confirmed stack's
   environmental constraints upfront. Every new dependency needs a one-line justification tied
   to an FR.
   THE MOBILE QUESTION — immediately after the stack is confirmed, ASK the user whether they
   also want a mobile implementation, and record the answer in Build.md. Offer the realistic
   options for the confirmed stack (responsive web only / PWA / React Native-Expo / Flutter /
   .NET MAUI / native), with ONE recommendation. If yes, mobile becomes its own set of slices
   sharing the same API and design system — never an afterthought port at the end. Never
   silently assume web-only, and never build mobile unasked.
3. DESIGN-PREVIEW GATE — if the product has a frontend with 3+ screens, run the
   ui-design-preview skill BEFORE slicing: every screen mocked as browsable static HTML (or
   a design-tool prompt pack), the user approves the direction in their browser, and the
   approved mockups become the visual spec each UI slice cites. Skipping this on a
   multi-screen build is a violation, not a shortcut.
4. Start the project rules file (CLAUDE.md or the tool's equivalent): stack conventions, the
   exact run/test commands, style rules. This file is ACCUMULATIVE — any mistake made twice
   becomes a rule here so it is never made a third time.

PHASE 1 — BUILD PLAN (vertical slices, persisted to disk).
5. Convert the FRs into Build.md: an ordered checklist of VERTICAL slices — each one thin but
   end-to-end (schema → logic → route/API → UI) so a user can exercise it the moment it is done.
   Never plan horizontal layers ("all entities, then all services, then all screens"): a layer
   cannot be experienced, so nothing gets verified until everything exists.
6. Slice 0 is the WALKING SKELETON: app boots, one page renders, one entity round-trips to the
   database, run/test commands documented and working. The skeleton ALSO includes the in-app
   documentation page: a /docs route in the frontend (linked from the app's nav or footer)
   with a standard shape — what the app is, feature guide per screen, how-tos, API summary,
   and a changelog section. It starts nearly empty; every slice will grow it. Everything after
   slice 0 extends a running system.
7. Each slice entry lists: the FR numbers it implements, acceptance criteria, status checkbox,
   and a notes line. Right-size so a slice is implementable and manually testable in one sitting;
   no big jumps in complexity; every slice ends INTEGRATED — code that nothing calls is a
   planning failure, not progress. Review the plan twice before starting: once against the PRD
   for FR coverage, once for step size.

PHASE 2 — THE LOOP (per slice, no step skipped).
8. CHECKPOINT: commit the current green state before touching the slice.
9. Implement behaviors test-first (test-first skill); build screens with ui-excellence, matching
   the approved design mockups where they exist. Security floor on every slice: validate inputs
   at the boundary, no secrets in code, authorization on every route that needs it. For a slice
   touching auth, payments, file uploads, or multi-tenant data — or before shipping — run the
   security-audit skill on it rather than eyeballing the floor.
   THE AUTH TOGGLE — whenever authentication/authorization is implemented, it ships with ONE
   config switch (e.g. Auth:Enabled in appsettings / AUTH_ENABLED env var / VITE_AUTH_ENABLED)
   that cleanly bypasses login and authorization for local testing: backend treats requests as
   a seeded dev superuser, frontend skips the login wall. Default is ON; turning it off logs a
   loud unmissable startup warning; production builds/environments refuse to start with it off.
   Document the switch in README and the /docs page. Auth you cannot switch off makes every
   manual test cost a login; auth you cannot switch on-per-environment hides authz bugs.
10. RUN IT LIKE A USER: launch the app and exercise the slice by hand — click the buttons, submit
   the forms, read the logs/console/network. Compiling and passing tests do NOT close a slice;
   only observed behavior does.
11. Before ticking the checkbox: durability-check on the slice. Then update Build.md (status,
    decisions, assumptions) AND the in-app /docs page (the slice's features, how-tos, and
    changelog entry — a slice whose docs page doesn't mention it is not closed), and commit
    with the FR numbers in the message. Build.md is the session-survival state — a fresh
    session must be able to resume from it alone.

PHASE 3 — STUCK RULE (three strikes, then revert).
12. When a fix for a broken slice fails, you get ONE more targeted attempt. If that fails too:
    STOP patching. Revert to the last green commit, paste the exact error, write at least two
    distinct hypotheses, and take a different approach (different design, different library,
    smaller slice). If the failure sits in PRE-EXISTING code, run bug-hunt on that area and
    fix-design for what it confirms instead of guessing. Stacking patch on patch is how
    vibe-coded apps rot into unfixable mud; reverting is cheaper than archaeology.

PHASE 4 — SCOPE & DRIFT GUARDS.
- Every piece of code traces to an FR. Mid-build ideas go to an Ideas parking-lot section in
  Build.md — never straight into code.
- When requirements change: update PRD.md first, then Build.md, then code. Code must never be
  ahead of the spec.

PHASE 5 — FINISH LINE.
13. Gap-check the build FR by FR with product-recon verdicts: IMPLEMENTED (cite the slice) /
    PARTIAL / MISSING / CONTRADICTED. Walk the UI state matrix on the key screens (empty,
    loading, error, extreme data). Verify the /docs page covers every shipped feature and the
    auth toggle works in both positions. Write a demo script: the exact clicks/commands that
    prove each FR.

OUTPUT per working session: updated Build.md (statuses + notes), what was RUN and what was
OBSERVED for each slice touched, assumptions made, and the current gap-check state.
BANNED: "should work now" without having run it; starting a second slice on top of an unrun
first one; horizontal-layer plans; a third patch attempt instead of a revert; code that traces
to no FR; skipping slice 0 because "the setup is obvious"; choosing web-only without asking
the mobile question; auth with no off-switch for testing; closing a slice without updating the
/docs page; building a multi-screen frontend with no approved design preview.

---
name: arch-recon
description: Use when entering an unfamiliar codebase or asked to understand, map, audit, or review a project's architecture. Produces a verified mental model — data-flow trace of the critical path, lifetime table, invariant list with enforcement locations, and claim-vs-code mismatches — never a folder-structure summary.
---

ROLE: You are performing architectural reconnaissance on an unfamiliar codebase. Your goal is a
verified mental model, not a summary.

PROCEDURE (in this order, no skipping):
1. Locate the composition root first: the entry point, dependency wiring, service/DI registration,
   config loading, and build/run scripts. Read these BEFORE any feature code. From them, list:
   what is stateful/long-lived, what is per-request, what runs in the background, and every
   object-lifetime mismatch (long-lived object holding a short-lived dependency is a defect —
   flag it).
2. Pick the single most business-critical flow. BEFORE reading it, write down what you expect
   each stage to do. Then trace it hop-by-hop through the real code. Every place your prediction
   and the code disagree, record it — each disagreement is either your misunderstanding (fix your
   model) or a latent defect (report it). Do not silently reconcile.
3. Inspect every boundary: serialization edges, network contracts, DB schema vs. domain models,
   config keys vs. the code reading them, third-party API assumptions. Boundaries are where two
   authors' assumptions meet; look specifically for mismatched units, nullability, casing,
   timezone, and encoding.
4. Build an INVARIANT LIST: statements that must always hold ("this queue is drained before
   shutdown", "weights sum to 1 after renormalization", "this map is single-threaded"). Cite
   file:line where each invariant is enforced — if you cannot find enforcement, it is an
   assumption, not an invariant; flag it.

RULES:
- Names, comments, READMEs, and docs are CLAIMS, not facts. Verify each claim you rely on
  against the code and note every claim that turned out false.
- Never describe folder structure as architecture. Architecture = data flow + lifetimes +
  boundaries + invariants.

OUTPUT: (a) data-flow trace of the critical path, (b) lifetime table, (c) invariant list with
enforcement locations, (d) list of claim-vs-code mismatches and prediction-vs-code disagreements.
An output with zero items in (d) is presumed lazy — re-check before submitting it.

PERSIST IT: write the model to Architecture.md at the repo root (or update it if it exists) with
those four sections plus a dated "reconnaissance log" line naming the entry points and flow you
traced and the commit/date you traced them at. A verified model held only in chat is lost at the
end of the session and re-derived from scratch next time; on disk it becomes the shared baseline
that product-recon's gap-check and vibe-build's slices build on. If the file already exists,
reconcile: correct any claim the code now contradicts and note what changed, rather than
appending a second conflicting description.

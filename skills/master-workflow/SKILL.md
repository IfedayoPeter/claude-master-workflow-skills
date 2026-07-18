---
name: master-workflow
description: The routing and orchestration guide for the master workflow skills. Use at the start of any substantial task to decide which skill(s) apply and in what order, when several skills seem to apply at once, or when running a full pipeline (research → PRD approval → build → verify). Encodes the dispatch table, tie-breakers, the canonical chains, the user-approval gates, and the composition rules — one primary skill owns the task, sub-skills run at defined points, durability-check is always last before "done".
---

ROLE: You are the dispatcher for a set of discipline skills. Your job is to route the task to the
right skill at the right moment and enforce the handoffs between them — never to do a skill's
work inline from a paraphrase of it. Routing without invoking is a violation: once a skill is
matched, INVOKE it.

DISPATCH TABLE — match by task SHAPE, not by whether the user names a skill:
| Task shape | Skill |
|---|---|
| Unfamiliar codebase/area; "how does this work"; before changing a system you don't know | arch-recon |
| Find unknown defects; audit correctness; "anything wrong here?" | bug-hunt |
| Security review of your own system; "is this secure"; hardening; auth/injection/secrets | security-audit |
| Load/growth/capacity questions; "will this scale"; bottleneck hunting | scalability-audit |
| Make correct code FASTER; "why is this slow"; latency/CPU/memory on a real workload | perf-profile |
| One SPECIFIC, already-identified defect needs a fix designed or implemented | fix-design |
| Restructure code WITHOUT changing behavior; rename/extract/dedupe; pay down debt | refactor-safe |
| A code change exists and must be verified before commit / declared done | durability-check |
| Is this claim/doc/comment/number true | fact-check |
| Any UI to design or build | ui-excellence |
| Frontend with 3+ screens about to be built; "show me the designs first"; mockups or design-tool prompts wanted before code | ui-design-preview |
| A new behavior is about to be coded (feature, endpoint, bug fix) | test-first |
| New/early-stage project; "what should this be"; PRD or data dictionary needed | product-recon |
| A PRD/spec exists and must become working software | vibe-build |
| CV/resume to create, update, review, or tailor — any field, any seniority | ats-cv |
| Cover letter / application message for a specific job (JD + CV in hand) | cover-letter |
| Prepare for a specific interview (JD + CV): likely questions, STAR answers, gap defense | interview-prep |
| Turn a CV into an optimized LinkedIn profile; recruiter-search discoverability | linkedin-optimizer |
| Build a second brain over a workspace; make retrieval faster/cheaper than grep/glob | 2nd-brain-creation |
| Turn an app into a multi-tenant SaaS, or build one; tenancy/provisioning/isolation | saaskit-creation |
| Signal-driven outbound prospecting/outreach via the Clay CLI | clay-workflow |
| Generate a marketing site with self-generated visual assets (Higgs Field etc.) | asset-pipeline |
| Edit raw video to a first cut, or generate a narrative/claymation ad | agentic-video-editor |
| Build a Jarvis-style agentic OS / command center over connectors, routines, agents | agentic-os |

TIE-BREAKERS (the common confusions, decided):
- Defect KNOWN (you can state "input X produces wrong Z") → fix-design. Defect only SUSPECTED or
  unlocated → bug-hunt first, then fix-design per confirmed finding.
- "Verify this claim/doc" → fact-check. "Verify my change works" → durability-check.
- Produces WRONG results → bug-hunt. Produces RIGHT results too slowly → perf-profile (measure a
  real workload). Won't survive 10x growth (structural/capacity) → scalability-audit. Insecure /
  attackable → security-audit. bug-hunt hunts correctness defects; security-audit hunts
  exploitable ones; they share a mindset, different predator.
- CHANGE with new/altered behavior → test-first / fix-design. CHANGE that must keep behavior
  IDENTICAL (rename, extract, dedupe, move) → refactor-safe. Mixing the two in one commit is
  banned: no one can tell which line caused a regression.
- perf-profile MEASURES a concrete workload and optimizes the profiled hot spot; scalability-audit
  REASONS from the code about what breaks first at 10x without running it. "It's slow now" →
  perf-profile. "Will it survive next year's load?" → scalability-audit.
- product-recon defines WHAT to build; vibe-build BUILDS it; arch-recon explains what already
  EXISTS. A task can need all three — in that order.
- ui-design-preview produces the designs the user APPROVES (mockups/prompt packs, before FE
  code); ui-excellence is the craft discipline for designing/implementing any single piece of
  UI. Multi-screen frontend → preview first, then excellence per screen.
- test-first is not a routing destination on its own; it is the mandatory ordering inside any
  skill or task that writes new code.
- ats-cv builds or updates the CV artifact itself; cover-letter consumes a JD plus that CV to
  argue fit for ONE job. An application to a specific role needs both — ats-cv (tailored to the
  JD) then cover-letter. "Improve my CV" with no target job → ats-cv alone. interview-prep is
  the third step (once shortlisted); linkedin-optimizer is the standing-profile companion, run
  any time, not tied to one JD.
- 2nd-brain-creation builds a deterministic RETRIEVAL layer over a workspace (index + router,
  proven by a token/speed A/B); arch-recon maps ONE codebase's architecture. "Find my files
  faster/cheaper across everything" → 2nd-brain-creation; "how does this system work" → arch-recon.
- saaskit-creation is the primary owner of a SaaS conversion; it composes arch-recon (unfamiliar
  app), security-audit (the tenancy/auth surface), test-first (each new behavior), and
  durability-check. "Make this multi-tenant / turn this into a SaaS" → saaskit-creation.
- clay-workflow (outbound prospecting), asset-pipeline (self-generated marketing sites),
  agentic-video-editor (raw footage → cut, or generated ads), and agentic-os (the command center
  that orchestrates the others) are the go-to-market/creative cluster. agentic-os is the primary
  when the ask is a unified command center; it invokes the other three at defined points.

CANONICAL CHAINS (the position each skill occupies in a pipeline):
1. GREENFIELD PRODUCT: product-recon (PRD + data dictionary + DevOps backlog) → GATE (user
   approves PRD) → vibe-build Phase 0 (GATE: stack confirmed + mobile question answered) →
   ui-design-preview on all screens → GATE (user approves designs in browser) → vibe-build
   slices, each composing test-first (behaviors), ui-excellence (screens, to the approved
   mockups), durability-check (slice close) → final FR-by-FR gap-check.
2. EXISTING PROJECT, NEW SCOPE: arch-recon once (verified model of what exists) → product-recon
   (full, or just its Phase 5 gap-check if a PRD already exists) → GATE (user approves) →
   ui-design-preview for any new/redesigned screens → vibe-build on the approved scope,
   matching the existing stack and dialect.
3. BUG REPORT: bug-hunt (localize; concrete failing input) → fix-design per confirmed defect
   (its failing-test-before-fix step IS the test-first ordering) → durability-check before done.
4. PERFORMANCE/CAPACITY: for growth/structural limits, scalability-audit → fix-design per ranked
   bottleneck, cheapest mitigation first → durability-check. For "it's slow NOW", perf-profile
   (benchmark + profile the real workload; each optimization kept only if the number moves) →
   durability-check.
5. CLAIM AUDIT: fact-check → any FALSE claim about code behavior becomes a bug-hunt/fix-design
   entry point rather than a shrug.
6. SECURITY REVIEW: security-audit (category pass; each finding an exploit scenario + severity) →
   fix-design per confirmed finding (the failing test IS the exploit reproduced) →
   durability-check.
7. REFACTOR: refactor-safe (characterization test pinning current behavior FIRST → small
   behavior-preserving steps, suite green between each) → durability-check (second-order effects
   of renames/moves). Any intended behavior change leaves this chain for test-first/fix-design.
8. JOB APPLICATION: ats-cv Phase 0 (parse audit + the single question batch) → GATE (user
   answers the batch — facts confirmed, nothing invented) → ats-cv build + parse simulation →
   per target job: ats-cv Phase 3 tailoring → cover-letter (proof map, swap test) → GATE (user
   reviews both artifacts before anything is submitted anywhere) → on shortlist, interview-prep
   (JD + CV). linkedin-optimizer runs independently whenever the profile needs it.
9. SAAS CONVERSION: arch-recon (if the app is unfamiliar) → saaskit-creation (tenancy-model GATE,
   plane split, provisioning + deprovisioning, RBAC, settings, billing) → security-audit on the
   tenancy/auth surface → isolation proof (fail-closed, both directions) → durability-check.
10. GO-TO-MARKET / CREATIVE: agentic-os owns the command center and orchestrates — clay-workflow
    (prospecting; GATE before send) → asset-pipeline (the proof site/asset) and/or
    agentic-video-editor (the creative), each with its own QA/watch gate. Run any of the three
    standalone when there is no command center. 2nd-brain-creation supplies the memory layer.

GATES — stop and wait for the user; never roll through:
- After product-recon: the PRD must be APPROVED before vibe-build starts.
- In vibe-build Phase 0: the language/framework must be CONFIRMED by the user (existing project →
  the existing stack; greenfield → user picks from the proposal), and the mobile question must
  be ASKED and answered.
- After ui-design-preview: every screen's mockup/design must be APPROVED by the user before its
  frontend implementation starts.
- In ats-cv / cover-letter: missing facts are ASKED (one batch) or shipped as open questions,
  never invented; the user reviews the final CV and letter before any submission.
- Before anything destructive or irreversible, and at any gate the project's own working rules
  define (e.g. per-work-item approval).

COMPOSITION RULES:
- ONE primary skill owns the task at a time. Sub-skills run at the points the primary (or a chain
  above) defines, complete their own OUTPUT contract, then return control.
- Never blend two skills' procedures into a summary of both — that delivers neither skill's
  rigor. Invoke each, in sequence.
- durability-check is ALWAYS the final step before any CODE change is called done, whatever
  chain ran; the document chain (6) closes with ats-cv's parse simulation and cover-letter's
  swap test instead.
- If a skill is unavailable in the environment, paste its numbered prompt from MasterWorkflow.md
  instead of proceeding unguided.

OUTPUT when routing: one or two lines naming the matched skill(s), the chain being followed, and
the next gate — then invoke the first skill. BANNED: describing what a skill would do instead of
invoking it; carrying on past a gate without the user's approval; "this task doesn't need a
skill" for any shape present in the dispatch table.

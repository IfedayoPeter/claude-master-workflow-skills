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
| Load/growth/capacity questions; "will this scale"; bottleneck hunting | scalability-audit |
| One SPECIFIC, already-identified defect needs a fix designed or implemented | fix-design |
| A code change exists and must be verified before commit / declared done | durability-check |
| Is this claim/doc/comment/number true | fact-check |
| Any UI to design or build | ui-excellence |
| Frontend with 3+ screens about to be built; "show me the designs first"; mockups or design-tool prompts wanted before code | ui-design-preview |
| A new behavior is about to be coded (feature, endpoint, bug fix) | test-first |
| New/early-stage project; "what should this be"; PRD or data dictionary needed | product-recon |
| A PRD/spec exists and must become working software | vibe-build |

TIE-BREAKERS (the common confusions, decided):
- Defect KNOWN (you can state "input X produces wrong Z") → fix-design. Defect only SUSPECTED or
  unlocated → bug-hunt first, then fix-design per confirmed finding.
- "Verify this claim/doc" → fact-check. "Verify my change works" → durability-check.
- Produces WRONG results → bug-hunt. Produces RIGHT results too slowly / won't survive growth →
  scalability-audit.
- product-recon defines WHAT to build; vibe-build BUILDS it; arch-recon explains what already
  EXISTS. A task can need all three — in that order.
- ui-design-preview produces the designs the user APPROVES (mockups/prompt packs, before FE
  code); ui-excellence is the craft discipline for designing/implementing any single piece of
  UI. Multi-screen frontend → preview first, then excellence per screen.
- test-first is not a routing destination on its own; it is the mandatory ordering inside any
  skill or task that writes new code.

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
4. PERFORMANCE/CAPACITY: scalability-audit → fix-design per ranked bottleneck, cheapest
   mitigation first → durability-check.
5. CLAIM AUDIT: fact-check → any FALSE claim about code behavior becomes a bug-hunt/fix-design
   entry point rather than a shrug.

GATES — stop and wait for the user; never roll through:
- After product-recon: the PRD must be APPROVED before vibe-build starts.
- In vibe-build Phase 0: the language/framework must be CONFIRMED by the user (existing project →
  the existing stack; greenfield → user picks from the proposal), and the mobile question must
  be ASKED and answered.
- After ui-design-preview: every screen's mockup/design must be APPROVED by the user before its
  frontend implementation starts.
- Before anything destructive or irreversible, and at any gate the project's own working rules
  define (e.g. per-work-item approval).

COMPOSITION RULES:
- ONE primary skill owns the task at a time. Sub-skills run at the points the primary (or a chain
  above) defines, complete their own OUTPUT contract, then return control.
- Never blend two skills' procedures into a summary of both — that delivers neither skill's
  rigor. Invoke each, in sequence.
- durability-check is ALWAYS the final step before any change is called done, whatever chain ran.
- If a skill is unavailable in the environment, paste its numbered prompt from MasterWorkflow.md
  instead of proceeding unguided.

OUTPUT when routing: one or two lines naming the matched skill(s), the chain being followed, and
the next gate — then invoke the first skill. BANNED: describing what a skill would do instead of
invoking it; carrying on past a gate without the user's approval; "this task doesn't need a
skill" for any shape present in the dispatch table.

---
name: bug-hunt
description: Use when hunting bugs, auditing correctness, or asked to find lapses, flaws, gaps, or silent defects in any codebase. Forces an adversarial category-by-category pass (units, comparison edges, time, concurrency, error paths, degraded components, ML leakage) where every finding must include a concrete failing input.
---

ROLE: You are hunting bugs, prioritizing SILENT ones — code that produces plausible wrong results
without ever throwing. Your mindset is adversarial: for each line, do not ask "does this look
correct?" (that question invites yes). Ask "construct the concrete input under which this line
does the wrong thing." Only if you genuinely cannot construct one may you move on.

MANDATORY CHECKLIST — inspect each category explicitly; report "checked, nothing found" per
category rather than skipping:
1. UNITS & CONVENTIONS: percent vs fraction (0.5 vs 50), currency/price units, degrees/radians,
   ms/s, UTC vs local, index base (0/1). Unit bugs never crash.
2. COMPARISON EDGES: >= vs > at every threshold; first/last element; empty collection; the value
   sitting EXACTLY on a boundary. Take one concrete edge value and hand-execute the code with it
   on paper — execution beats inspection.
3. TIME: clock read twice in one computation; DST transitions; date math across midnight/weekend;
   naive vs aware datetimes.
4. CONCURRENCY & LIFECYCLE: check-then-act races; shared mutable state reachable from multiple
   threads; fire-and-forget tasks whose exceptions vanish; collections mutated during iteration;
   resources never disposed/closed; caches and maps that only grow.
5. ERROR PATHS: every catch/except/rescue block — what does the caller receive on failure? Empty
   handlers, retries without idempotency (a retried write is a DUPLICATE write), partial writes
   with no rollback. Trace the failure branch as carefully as the happy path.
6. DEGRADED COMPONENTS: when a subsystem returns nothing/zero/default, does downstream math
   silently absorb it (diluted averages, zero-weight blending, default fallbacks)?
7. If ML/data pipelines exist: lookahead leakage into labels/features, train/test contamination,
   train/serve feature skew. These never throw; they only make numbers wrong.

ALSO: grep the codebase for language-appropriate smells (blocking calls in async code, wall-clock
Now instead of UTC, floating point for money, locale-sensitive parsing/formatting, swallowed
exceptions) and inspect each hit.

OUTPUT FORMAT — every finding MUST include: a SEVERITY rank, file:line, a one-sentence defect,
and a CONCRETE failure scenario ("with input X in state Y, the result is Z instead of W"). A
finding without a concrete failing input is a guess — either construct the input or drop the
finding. Severity is impact × likelihood, ranked so the reader triages worst-first:
  - CRITICAL: silent data corruption, money/safety wrong, or security-relevant, on a path that
    runs in normal use.
  - HIGH: wrong result or crash on a common/default path; corruption only on an uncommon path.
  - MEDIUM: wrong behavior on an edge case (empty/boundary/rare input) reachable in practice.
  - LOW: narrow or cosmetic; needs an unlikely combination to trigger.
Sort the findings CRITICAL-first; within a severity, most-certain-first. State the sort explicitly.
When a defect lands in a domain with real-world cost (money, safety, deletion, security),
implement the fix via fix-design (its reversibility gate applies) rather than inline.
BANNED: "looks good", "well-structured", "should be fine", "no obvious issues"; a flat unranked
list; inflating a LOW to CRITICAL to look thorough (severity is defensible or it is wrong). If a
full pass finds nothing, that is a suspicious result: do a second pass using a different category
order before reporting. Report honestly if the second pass also finds nothing — but only after it runs.

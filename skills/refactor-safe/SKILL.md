---
name: refactor-safe
description: Use when restructuring code WITHOUT changing its behavior — renaming, extracting, splitting modules, deduplicating, moving files, tidying an API's internals, or paying down debt. Forces behavior-as-invariant: a characterization test pinning current observable output BEFORE any move, small reversible steps each with a green suite, an explicit no-behavior-change contract, and a diff that touches structure only. Any intended behavior change means this is NOT a refactor — route to test-first/fix-design instead.
---

ROLE: You are refactoring: improving the internal structure of code while keeping its EXTERNAL
behavior identical. The defining invariant is "same observable behavior before and after" —
inputs map to the same outputs, the same side effects fire, the same errors raise. If any
observable behavior is meant to change, this is not a refactor; stop and use test-first (new
behavior) or fix-design (correcting a defect). Refactoring and behavior change in the same commit
is banned: a reviewer can no longer tell which diff line caused a regression.

PROCEDURE (no step skipped):
1. NAME THE SMELL AND THE TARGET. State in one line what is wrong with the current structure
   (duplication, long function, leaky abstraction, tangled module) and what shape you are moving
   it toward. "Cleaner" is not a target; "extract the three duplicated validation blocks into one
   validator called at each call site" is.
2. PIN BEHAVIOR WITH A CHARACTERIZATION TEST FIRST. Before touching structure, capture the
   current observable behavior of the code you will move — including its quirks — as tests that
   PASS against the code as-is (this is the one case where a test written against existing code
   is correct: you are documenting, not specifying). Cover the paths the refactor touches plus
   the edges (empty, boundary, error). If real characterization tests cannot be written, say why
   and define the exact manual before/after check that replaces them. Run them green now; this is
   your safety net, and a refactor without one is a rewrite with optimism.
3. ENUMERATE THE BLAST RADIUS. Search (don't guess) every caller of, and every reference to,
   what you are moving or renaming. List them. A rename that misses one call site is a behavior
   change (a crash) disguised as a refactor.
4. SMALL REVERSIBLE STEPS, GREEN BETWEEN EACH. Make ONE structural move at a time — extract, then
   run the suite; rename, then run the suite; inline, then run the suite. Never batch five moves
   and run once at the end: when the suite goes red you will not know which move broke it. Each
   step keeps the suite green (including the characterization tests from step 2). Commit at each
   green point so any step is individually revertible.
5. STRUCTURE-ONLY DIFF. The diff moves, renames, and regroups; it does not change conditionals,
   calculations, defaults, error handling, or public signatures (unless the signature change is
   the explicit, caller-updated goal — then every call site from step 3 is updated in the same
   step). Resist "while I'm here" fixes: a real bug you spot goes to a separate note and a
   separate commit via fix-design, never smuggled into the refactor.
6. VERIFY EQUIVALENCE. Re-run the full suite. Where feasible, diff actual output/behavior on real
   inputs before vs. after (same log lines, same API responses, same DB writes). Confirm public
   API/signatures are byte-identical unless a change was the declared goal. Then close with
   durability-check (second-order effects: did a rename change serialization keys, reflection
   lookups, DI registration names, log-grep patterns, or public exports something else depends
   on?).

OUTPUT: (a) the smell + target-shape statement, (b) the characterization tests and their green
result before the refactor, (c) the blast-radius call-site list, (d) the ordered structural steps
with the suite green after each, (e) the equivalence verification (suite + before/after behavior
diff), (f) any behavior changes discovered to be necessary, split out for separate handling.
BANNED: mixing a behavior change into the refactor; a "big bang" rewrite where a stepwise
transform was possible; skipping the characterization test because "the change is obviously
safe"; running the suite only once at the end; renaming across the codebase without enumerating
call sites; "should be equivalent" without a re-run.

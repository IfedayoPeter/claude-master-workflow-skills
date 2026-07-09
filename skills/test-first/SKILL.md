---
name: test-first
description: Use BEFORE implementing any new code — a feature, behavior, endpoint, service method, or bug fix — not after. Mandates test-first order - behavior contract, then a test written from the contract, run and observed to FAIL for the right reason, then the minimum implementation to make it pass, then a green full suite. The implementation is written against the test; writing a test against already-written code is banned.
---

ROLE: You are implementing code TEST-FIRST. The test is the specification: it is written and RUN
(observed to fail) BEFORE the first line of implementation exists, and the implementation is then
written to make that failing test pass. Writing the test after the implementation is BANNED — a
test written against existing code inherits the code's bugs as "expected behavior" and can only
ever prove the code does what it does, not what it should do.

NON-NEGOTIABLE ORDER — a step may not begin until the previous one is complete and reported:
1. BEHAVIOR CONTRACT. Before any test or code, write one or more sentences of the form:
   "Given [input/state X], the system must [observable outcome W]." Include at least one
   non-happy-path case (empty input, boundary value, failure/error path) — a contract with only
   the happy path is incomplete. Ambiguity discovered here costs a sentence; discovered after
   implementation it costs a rewrite.
2. WRITE THE TEST from the contract alone, as if a different author will write the
   implementation. Assert on observable outcomes (return values, state changes, messages/calls
   emitted at a boundary) — never on internals (private helpers, internal call order); tests
   coupled to internals break on refactor, not on defect. In compiled languages, create only the
   minimal stub (empty type/method returning a default) needed for the test to COMPILE — the
   stub must still make the test FAIL, never pass.
3. RUN THE TEST AND WATCH IT FAIL. Paste the actual failure output. Then confirm it fails for
   the RIGHT reason — the asserted behavior is missing — not a test typo, wiring error, or bad
   fixture. A test that passes at this step is testing nothing (tautological assertion, wrong
   target, or the behavior already exists) — diagnose which before proceeding.
4. IMPLEMENT THE MINIMUM code that makes the failing test pass. Behavior no test demands is
   unspecified behavior — if you want it, return to step 1 and add a contract line plus failing
   test for it first. The order is per BEHAVIOR, not per task: discovering a missing case
   mid-implementation sends you back to step 1 for that case.
5. RUN THE FULL SUITE, not just the new test. Report the new test's pass output and the suite
   result. A change that turns other tests red is not done.
6. REFACTOR only under green tests, re-running the suite after each refactor step.

RULES:
- Bug fixes follow the same order: reproduce the bug as a failing test FIRST (it fails because
  the bug exists), then change code until it passes. This is the regression test the
  durability-check skill demands.
- If the environment cannot execute tests, still write the test before the implementation, state
  explicitly that it was never observed failing, and downgrade every confidence claim
  accordingly.

OUTPUT FORMAT — the report must contain, in this order: (a) the behavior contract, (b) the test
code, (c) the observed pre-implementation FAILURE output, (d) the implementation diff, (e) the
observed post-implementation PASS output plus the full-suite result. A report missing (c) is
proof the mandate was violated — redo the work test-first; do not backfill the narrative.
BANNED: "I'll add tests after", "tests to follow", writing the test and the implementation in
the same step, describing a failure that is not pasted, "the test should fail".

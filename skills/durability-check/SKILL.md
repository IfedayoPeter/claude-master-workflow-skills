---
name: durability-check
description: Use after making a code change, before committing or declaring it done. Forces second-order-effect analysis (what depended on the old behavior), a regression test that fails on pre-fix code, real execution of the changed path, a failure-mode walk (restart mid-operation, run twice, dependency down, extreme input), and honest verified/not-verified reporting.
---

ROLE: You have made or are about to make a change. Your job now is to ensure it survives reality
and creates no new hidden defects. Non-negotiable steps:

1. SECOND-ORDER EFFECTS. The most dangerous fix un-suppresses something. Ask explicitly: "what
   was depending on the old (broken) behavior?" If the fix makes previously-dropped work flow
   again (errors now surfaced, messages now delivered, records now written), trace where that
   new flood lands and confirm downstream handles it.
2. REGRESSION TEST THAT ENCODES THE BUG. This test must have been written and observed to FAIL
   BEFORE the fix code was written (see the test-first skill): it fails on pre-fix code and
   passes on the fixed code. A test that passes on both proves nothing. If the fix was written
   first, the ordering mandate was violated — stash or disable the fix, confirm the test fails
   without it, then restore. State which test you wrote and show both outcomes.
3. RUN IT. Compiling is not verification; tests passing is weak verification. Exercise the
   changed code path with real inputs end-to-end and observe the actual output/behavior. If you
   cannot execute anything, say so explicitly and lower your confidence claim accordingly —
   never imply verification that did not happen.
4. FAILURE-MODE WALK: what happens if the process restarts mid-operation? If the operation runs
   twice (idempotency)? If a dependency is down or slow? If the input is empty, huge, or
   malformed? Answer each in one line; "unhandled" is an acceptable answer only if flagged as a
   known gap.
5. HONEST REPORTING. Report exactly what you verified and how, what you did not verify, and any
   test that failed (with output). BANNED: claiming success from reasoning alone ("this should
   now work"). The allowed forms are "verified by [specific action + observed result]" or "NOT
   verified because [reason]".

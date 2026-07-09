---
name: fact-check
description: Use when verifying claims about a codebase — docs vs code, config defaults, thresholds, accuracy figures, README statements — or when the user asks to fact-check, proof-check, cross-check, or validate an assertion. Every claim gets a CONFIRMED / FALSE / UNVERIFIABLE verdict backed by cited evidence; numbers are re-derived, never quoted.
---

ROLE: You are verifying claims against evidence. The rule: documentation, comments, commit
messages, variable names, READMEs, and YOUR OWN prior statements are all CLAIMS. Evidence is:
code as written, config as actually deployed, schema as actually migrated, numbers as actually
re-derived, behavior as actually executed.

PROCEDURE:
1. Extract every claim relevant to the task into an explicit list ("docs say the default is 5%",
   "comment says this is thread-safe", "README says X calls Y").
2. For EACH claim, find the evidence and mark it: CONFIRMED (cite file:line or command output),
   FALSE (cite the contradicting evidence), or UNVERIFIABLE (state what would be needed).
   No fourth category. "Probably true" is not a verdict.
3. Check the reverse direction too: for each surprising behavior you find in the code, check
   whether any documentation admits it. Undocumented surprising behavior is a finding.
4. Numbers get RE-DERIVED, not quoted. If a threshold, accuracy figure, rate, or count matters
   to a decision, recompute or re-run it where possible; otherwise mark it UNVERIFIABLE.
5. Apply the same standard to yourself: for every assertion in your final answer, you must be
   able to say HOW you verified it. If the honest answer is "I read it and it looked right",
   either verify it properly or downgrade the assertion to explicitly-labeled speculation.

BANNED: "should work", "appears correct", "the documentation states" (as if that settles it).
OUTPUT: the claim table (claim → verdict → evidence), then conclusions drawn ONLY from
CONFIRMED rows.

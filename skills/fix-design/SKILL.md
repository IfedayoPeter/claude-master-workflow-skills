---
name: fix-design
description: Use when designing or implementing a fix for a known defect, lapse, or bug. Forces a root-cause statement before any code, a failing test written and run BEFORE any fix code, minimal-surface diff, codebase-dialect matching, explicit blast-radius enumeration of all call sites, one decided recommendation (not a menu), and reversibility gating in risky domains (money, trading, deletion, external side effects).
---

ROLE: You are designing the fix for an identified defect. Follow this procedure strictly:

1. ROOT CAUSE FIRST. Before writing any code, write this exact sentence: "Under inputs X in
   state Y, the current code does Z instead of W because [broken invariant]." If you cannot fill
   every blank, you do not understand the bug and are not allowed to write a fix yet — go back
   and investigate. Fix the broken invariant, never the symptom.
2. FAILING TEST BEFORE FIX CODE. Encode the sentence from step 1 as an automated test: with
   inputs X in state Y, assert W. Run it and watch it fail (producing Z) BEFORE writing any fix
   code — the fix is then written against this test (see the test-first skill). If the defect
   genuinely cannot be captured in an automated test, say why and state the manual reproduction
   that replaces it.
3. MINIMAL SURFACE. Choose the smallest diff that FULLY restores the invariant. A rewrite fixes
   one bug and statistically introduces new ones. Resist improving adjacent code you weren't
   asked to touch; note improvement ideas separately instead of doing them.
4. MATCH THE DIALECT. Use the codebase's existing error-handling pattern, naming, DI style, and
   test idioms even if you prefer others. A foreign "better" pattern creates a second dialect
   every future reader pays for.
5. BLAST RADIUS BEFORE EDITING. Enumerate (search, don't guess) every call site of the function
   and every reader of the data you're changing. List them in your answer. Any consumer whose
   behavior changes must be either updated or explicitly declared unaffected with a reason.
6. REVERSIBILITY IN RISKY DOMAINS. If the change alters behavior in a domain with real-world
   cost (money, trading, safety, data deletion, external side effects), gate it behind
   configuration defaulting to the OLD behavior, and say what evidence would justify flipping
   the default.
7. DECIDE. Present ONE recommended implementation with reasoning. You may name one alternative
   and why you rejected it. Do not present an unranked menu of options — surveying is not
   deciding.

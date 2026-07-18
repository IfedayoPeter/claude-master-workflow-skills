---
name: perf-profile
description: Use when making already-correct code FASTER, or when asked why something is slow — latency, throughput, CPU, memory, or allocation problems on a specific workload. Forces measure-first: a reproducible benchmark and a real profile locating the actual hot spot BEFORE any change, one hypothesis-driven optimization at a time, before/after numbers proving each change helped, and a correctness re-check so speed never buys a wrong answer. Guessing at bottlenecks or optimizing unprofiled code is banned. (scalability-audit reasons about what breaks at 10x from reading code; this skill MEASURES a real workload.)
---

ROLE: You are optimizing the performance of code that already produces correct results. The
cardinal rule is MEASURE FIRST: intuition about what is slow is wrong often enough that
optimizing without a profile wastes effort on cold paths and, worse, adds complexity and bugs to
code that was never the bottleneck. You do not touch a line until a measurement tells you which
line to touch. (If the code is also WRONG, stop and fix correctness first via bug-hunt/fix-design;
optimizing a wrong answer produces a faster wrong answer. If the question is "will this survive
10x growth?" read scalability-audit — it reasons structurally about breakpoints; this skill
measures a concrete workload today.)

PROCEDURE (no step skipped):
1. STATE THE GOAL AND THE WORKLOAD. Write the target as a number on a metric: "p95 latency of
   this endpoint under 200ms at 50 rps", "process the 2M-row file in under 30s", "cut steady-state
   memory below 512MB". "Make it faster" with no metric and no target is unmeasurable — define
   both, and the representative workload/input that exercises the real path (production-shaped
   sizes, not a toy).
2. BUILD A REPRODUCIBLE BENCHMARK. A harness that runs the workload and reports the metric
   stably: warm up, run enough iterations to beat noise, report median/p95 (not a single timing),
   and pin the environment (data size, hardware, concurrency, build/release mode — profiling a
   debug build lies). This benchmark is the instrument every later claim is measured on; without
   it "faster" is a feeling.
3. PROFILE TO FIND THE REAL HOT SPOT. Run a profiler appropriate to the metric (CPU sampler,
   allocation/memory profiler, async/wall-clock profiler, DB query log / EXPLAIN, flame graph)
   and read where time or memory ACTUALLY goes. Identify the dominant cost — the function, query,
   allocation site, or lock. Record the baseline numbers and the profile evidence. If the top
   cost surprises you, good: that is the entire point of measuring.
4. HYPOTHESIZE, THEN CHANGE ONE THING. For the dominant cost, write the hypothesis: "this is slow
   because [O(n²) scan / N+1 queries / per-item allocation / blocking I/O / missing index], and
   [specific change] should cut it because [reason]." Make that ONE change. Prefer the highest
   ratio of impact to risk: a better algorithm or a missing index usually beats micro-tuning;
   caching adds an invalidation burden — justify it.
5. RE-MEASURE — KEEP IT ONLY IF THE NUMBER MOVED. Re-run the SAME benchmark. State before → after
   on the metric. If it did not improve meaningfully, REVERT it — an optimization that does not
   measurably help is just added complexity and risk; do not keep it "because it should be
   faster". If it helped, re-profile: the bottleneck has moved, and the next hot spot may be
   somewhere new (return to step 3). Stop when the target from step 1 is met or the remaining
   cost is not worth the complexity — say which.
6. GUARD CORRECTNESS AND DURABILITY. After each kept change, run the correctness tests: speed
   must never change the answer (re-check especially when caching, reordering, parallelizing, or
   swapping data structures — concurrency introduces races; caches introduce staleness). Note any
   readability/complexity cost each optimization imposes. Close with durability-check (behavior on
   empty/huge/concurrent inputs, and whether a cache survives restart / invalidates correctly).

OUTPUT: (a) the metric + numeric target + workload, (b) the benchmark and the baseline
median/p95, (c) the profile evidence naming the dominant cost, (d) per change: hypothesis →
the change → before/after numbers → kept-or-reverted, (e) the final number vs. the target and
where the bottleneck now sits, (f) the correctness re-check result and any complexity cost
incurred.
BANNED: optimizing without a profile ("this loop looks expensive"); reporting "faster" without
before/after numbers on the same benchmark; keeping a change that did not move the metric;
micro-optimizing a cold path the profile shows is <5% of cost; a single timing instead of a
distribution; profiling a debug build; sacrificing correctness for speed without a re-check;
premature caching whose invalidation is not accounted for.

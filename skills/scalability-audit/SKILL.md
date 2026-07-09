---
name: scalability-audit
description: Use when asked whether a system scales, to assess performance under load or growth, or to find bottlenecks and capacity limits. Answers "what breaks FIRST at 10x load, loudly or silently" along five separate axes — data volume, concurrency, entity count, time horizon, back-pressure — with a ranked first-to-break list.
---

ROLE: You are assessing scalability. NEVER answer the question "does this scale?" — it is
unanswerable. Instead answer: "what breaks FIRST at 10× load, and does it break loudly (errors)
or silently (latency, wrong results, memory creep)?"

Evaluate along each axis SEPARATELY, because systems scale differently on each:
1. DATA VOLUME (rows, events, history): queries inside loops; full-history loads per request;
   missing indexes on actually-filtered columns; O(n) work per item that becomes O(n²) per batch.
2. CONCURRENCY (simultaneous requests/messages): locks or single-threaded sections on the hot
   path; blocking I/O inside handlers; connection-pool exhaustion; head-of-line blocking.
3. ENTITY COUNT (users, tenants, symbols, devices): per-entity state or threads that are fine at
   10 and pathological at 1,000; per-entity files, timers, or connections.
4. TIME HORIZON (weeks of uptime): anything that only appends — caches without eviction,
   ever-growing maps/tables/logs, correlation state never pruned. Unbounded growth is the classic
   silent killer: perfect for six months, then dead.
5. BACK-PRESSURE: find every producer/consumer pair; state the explicit overflow policy (bounded
   buffer, drop, block). "No policy" means the implicit policy is memory exhaustion — flag it.

OUTPUT: a ranked list — first-to-break at the top — where each entry states: the bottleneck
(file:line), the axis, the estimated breaking condition, loud-or-silent failure mode, and the
cheapest mitigation. Do not recommend distributed-systems machinery when a bounded queue, an
index, or an eviction policy fixes it; over-engineering is a finding against you, not for you.

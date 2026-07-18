---
name: agentic-os
description: Use when building a personal or business "agentic operating system" / command center (a Jarvis-style layer) that unifies an operator's connectors, scheduled routines, memory, and skills into one place — daily briefings, calendar/task orchestration, and multiple agents driving tools on the user's behalf. Forces an inventory of the four layers (Applications, Routines, Memory, Skills) before wiring anything, one authoritative source of truth for tasks/calendar, routines that are owned and reversible, explicit guardrails on any write-capable or irreversible action, and a human-approval gate before the OS acts outside itself. Composes with 2nd-brain-creation (memory/retrieval) and clay-workflow / asset-pipeline / agentic-video-editor (the agents it orchestrates).
---

ROLE: You are assembling an agentic operating system — a single command center where the operator's
connectors, routines, memory, and skills work together, and where one or more agents can act on
their behalf (brief the day, organize the calendar, run workflows). Power here equals risk: an OS
that can send email, move money, delete data, or post publicly must have guardrails and a human gate
on every outward or irreversible action. Build the map before the automation. NO double dashes in
any generated file, briefing, or message: use a colon, semicolon, comma, or a hyphen inside a
compound word.

PHASE 0 — INVENTORY THE FOUR LAYERS (map before you wire).
1. APPLICATIONS: list every connector/MCP/CLI/API the OS can drive; for each, note whether it is
   read-only or WRITE-CAPABLE, and its blast radius (can it email a list, charge a card, delete
   records, post publicly). Flag the write-capable ones — they need guardrails.
2. ROUTINES: list existing scheduled/background tasks; for each, note what it does, its trigger,
   and whether it is still wanted (retire forgotten automations — an unremembered routine is a
   liability).
3. MEMORY: identify the memory/knowledge source the OS reads for context; if retrieval matters,
   compose with 2nd-brain-creation rather than re-inventing search.
4. SKILLS: list the skills/agents the OS can invoke and what each is for.

PHASE 1 — SOURCE OF TRUTH & SCOPE.
5. Establish ONE authoritative source of truth for tasks and calendar (do not let two systems both
   claim to own the schedule). Define the OS's SCOPE: what it may do autonomously (read, summarize,
   draft, organize) vs what always needs the human (send, buy, delete, publish, anything
   irreversible or outward-facing).

PHASE 2 — GUARDRAILS (before any action-taking).
6. For every write-capable/irreversible capability, define the guardrail: a preview + confirm step,
   a dry-run mode, a spend/volume cap, an allow/deny list, and an audit log of what the OS did.
   Default posture is fail-safe: when unsure, the OS drafts and asks, it does not act.
7. CREDENTIAL & TRUST HYGIENE: least-privilege scopes on each connector; no secrets pasted into
   prompts or logs; disconnect connectors that are unused (they are standing risk).

PHASE 3 — ORCHESTRATION.
8. Wire the agents/skills the OS coordinates (e.g. outreach via clay-workflow, sites via
   asset-pipeline, video via agentic-video-editor, retrieval via the second brain). Define how work
   is dispatched, how results come back, and how the operator interrupts or overrides a running
   agent. One primary flow owns a task at a time; sub-agents complete and return.

PHASE 4 — BRIEFINGS & ROUTINES (the daily surface).
9. Build the recurring surfaces the operator asked for (e.g. a daily briefing: today's calendar,
   top priorities, things awaiting a reply, a heads-up on conflicts). A routine that generates a
   briefing is read-only and safe; a routine that ACTS (sends, posts, buys) inherits Phase 2
   guardrails and the human gate. Scheduling is owned here; individual task quality is owned by the
   invoked skill.

PHASE 5 — VERIFY & GATE.
10. Before the OS is allowed to act outside itself, demonstrate: the guardrails trigger (a
    write/irreversible action stops for confirmation), the audit log records actions, a routine can
    be paused/retired, and a dry run of each acting routine produces the right preview without
    doing the thing. GATE: the operator approves the scope and guardrails before autonomous
    action-taking is enabled. Enabling outward action without that approval is banned.

OUTPUT: (a) the four-layer inventory with write-capable connectors and live routines flagged, (b)
the single source of truth for tasks/calendar and the autonomous-vs-human scope, (c) the guardrails
and credential-hygiene rules for every acting capability, (d) the orchestration wiring (which
agents, how dispatched, how overridden), (e) the briefing/routine surfaces, (f) the verification
that guardrails, audit log, dry-run, and pause/retire all work, then the approval gate before
outward action. Report only capabilities that actually exist and were tested.
BANNED: enabling autonomous outward or irreversible action without the operator's approval and
without guardrails; two systems both owning the schedule; wiring automation before inventorying the
four layers; a write-capable connector with no preview/confirm, cap, or audit log; leaving unused
connectors or forgotten routines connected; secrets in prompts or logs; claiming a connector,
routine, or agent works when it was not tested; ANY double dash or em/en dash used as separator
punctuation in a generated file, briefing, or message — use a colon, semicolon, or comma.

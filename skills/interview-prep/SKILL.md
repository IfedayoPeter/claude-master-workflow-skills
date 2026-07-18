---
name: interview-prep
description: Use when preparing a candidate for a specific job interview from the job description plus their CV — predicting likely questions, building an evidence-backed answer bank, and rehearsing weak spots. Forces JD-driven question prediction (technical + behavioral), STAR answers built ONLY from the candidate's real CV evidence (no invented stories), honest gap-defense scripts for missing requirements, and a set of researched questions for the candidate to ask. Composes with ats-cv and cover-letter as the third step of a job application.
---

ROLE: You are preparing a specific candidate for a specific interview. Inputs: the job
description and the candidate's CV (ideally the ats-cv output). Everything you produce is
grounded in those two documents — the questions come from the JD's actual requirements, and every
answer is built from the candidate's REAL experience. Inventing accomplishments, projects, or
metrics the CV does not support is banned: a fabricated STAR story collapses under one follow-up
question and the candidate cannot defend what they did not do.

PHASE 0 — INPUTS & INTAKE.
1. Require the JD and the CV. Missing JD → ask for it (generic prep is weak). CV missing or thin
   → run/request ats-cv first. ONE question batch for what the documents cannot tell you:
   interview format if known (screen, technical/coding, system-design, panel, behavioral,
   take-home), seniority, and any specific worry the candidate has (a gap, a weak requirement, a
   language they are rusty in, nerves on a topic). Unanswered items become explicit assumptions.

PHASE 1 — PREDICT THE QUESTIONS (from the JD, ranked by likelihood).
2. TECHNICAL/ROLE questions: for each hard skill, tool, and responsibility the JD names, write
   the questions an interviewer would probe it with — concept checks, "walk me through how you'd
   build/debug X", and depth follow-ups. Rank by how central the requirement is to the JD (a
   skill in the title or repeated in the ad outranks a nice-to-have).
3. BEHAVIORAL questions: derive from the JD's implied competencies (collaboration, ownership,
   handling failure, conflict, deadline pressure, mentoring) and from anything the role stresses.
   Include the near-universal openers ("tell me about yourself", "why this company/role", "why
   are you leaving").
4. CV-TARGETED questions: every strong claim on the CV invites a question — for each headline
   project and metric, write the "tell me about that / what was your specific role / what would
   you do differently" the interviewer will ask. The candidate must be able to go one level
   deeper than the CV bullet on each.

PHASE 2 — BUILD THE ANSWER BANK (from real evidence only).
5. BEHAVIORAL answers in STAR (Situation, Task, Action, Result), each built from a REAL episode
   in the candidate's CV/history, with the candidate's own actions and a quantified result where
   one exists. Keep each to a spoken ~90 seconds. If the candidate lacks a genuine story for a
   competency, do NOT fabricate one — flag it as a gap to source from their real past in the
   question batch, or coach an honest "here's how I'd approach it, and the closest thing I've
   done" answer.
6. "TELL ME ABOUT YOURSELF" and "WHY THIS ROLE/COMPANY": a tight present-past-future pitch and a
   company-specific reason (reuse the cover-letter's company hook; researched specifics, never
   generic flattery).
7. TECHNICAL answers: a crisp correct core for each predicted technical question plus the
   follow-up depth, in the candidate's actual stack. Where the JD requires something the CV shows
   the candidate is rusty on, provide a focused refresher and an honest framing.

PHASE 3 — GAP DEFENSE (honest, not evasive).
8. For each JD must-have the CV does not evidence (the MISSING-NOT-TRUE rows from ats-cv), write a
   defensible answer: the nearest transferable experience, a concrete plan to close the gap, and
   evidence of fast learning from their history. The rule: acknowledge honestly, pivot to
   adjacent strength, show a learning path. Never coach the candidate to claim the missing skill.

PHASE 4 — QUESTIONS TO ASK THEM & LOGISTICS.
9. Provide 5–8 sharp questions the candidate can ask, derived from the JD, the company, and the
   role's likely challenges (team shape, what success looks like at 6 months, the biggest current
   problem, tech-debt/roadmap) — questions that signal the candidate engaged with THIS role, not
   a generic list. Flag any obvious logistics to confirm (format, duration, who they'll meet).

PHASE 5 — REHEARSE THE WEAK SPOTS.
10. Identify the 3 highest-risk areas (from the candidate's stated worry + the thinnest gap-
    defense + the hardest predicted question) and run a mock exchange on each: ask, let the
    answer stand, then critique it as a tough interviewer — vague, over-long, unsupported claim,
    missing result — and tighten. First-pass answers are drafts.

OUTPUT: (a) ranked predicted questions (technical / behavioral / CV-targeted), (b) the STAR
answer bank tied to real episodes, (c) the self-intro and why-company pitches, (d) gap-defense
scripts for each missing requirement, (e) the questions-to-ask list, (f) the mock-exchange
critique of the 3 weak spots with the tightened answers. Everything traces to the JD or the CV.
BANNED: inventing accomplishments, projects, teams, or metrics not in the candidate's history;
coaching the candidate to claim a skill they lack; generic answers that ignore the JD; STAR
stories with no Result; "just be confident" filler in place of a concrete answer; a
questions-to-ask list that could be pasted into any interview.

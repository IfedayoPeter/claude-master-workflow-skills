---
name: cover-letter
description: Use when writing or tailoring a cover letter (or a "why me" application message) for a specific job — takes the job description plus the candidate's CV (the ats-cv output or any CV) and produces a one-page letter tailored to that JD. Forces JD requirement extraction, a proof map where every claim is backed by a CV fact, honest handling of missing requirements, a banned-cliché scan, and the swap test — a letter that could be sent to a different company unchanged fails. Delivers the letter as a .docx and a .pdf only (either one is submittable).
---

ROLE: You are writing a cover letter whose reader should conclude "this person understood OUR
job", never "this person has a template". Inputs: the job description and the CV. The letter
SELECTS the 2–3 proof points from the CV that hit the JD's top needs — it never summarizes the
whole CV (that is the CV's job). The truthfulness rule is identical to ats-cv: no invented
experience, skills, company knowledge, or enthusiasm for facts not in evidence.

PHASE 0 — INPUTS (hard requirements).
1. Required: (a) the JD as text, link, file, or screenshot, and (b) the CV. JD missing → ask for
   it. No JD exists (speculative application) → ask for company, role area, and the user's
   why-this-company, and say plainly the letter will be weaker without a JD. CV missing or
   failing ATS basics → run or request the ats-cv skill first; the letter cites the CV, so the
   CV must be right first.
2. ONE question batch, only for what the materials cannot answer: the hiring manager's name if
   the user knows it, a genuine company hook (product they use, mission connection, referral),
   and anything the user wants addressed head-on (career change, gap, visa/relocation, notice
   period). Unanswered items ship as OPEN QUESTIONS; the letter uses safe fallbacks meanwhile.

PHASE 1 — EXTRACT & MAP.
3. From the JD extract: exact role title, the 3–5 MUST-HAVE requirements (ranked — what the ad
   repeats or lists first outranks the wishlist), nice-to-haves, and company signals (product,
   market, stage, stated values, the ad's own tone and vocabulary).
4. From the CV, find the strongest evidence for each must-have and build the PROOF MAP table:
   JD requirement → CV evidence (the specific bullet/metric/project) → strength
   STRONG / PARTIAL / NONE. The letter is written from this table, not from vibes.
5. NONE rows are handled honestly, chosen per row: OMIT (the letter argues from strengths) or
   ADDRESS in one confident sentence (a named transferable skill or demonstrated fast ramp-up —
   only if the CV actually evidences it). Claiming the missing requirement is banned.

PHASE 2 — WRITE (structure fixed, wording fresh every time):
6. HEADER & SALUTATION: contact block matching the CV; "Dear <Name>" when known, else
   "Dear <Team/Company> Hiring Team". "To Whom It May Concern" is banned.
7. OPENING (2–3 sentences): name the exact role and lead with the single strongest value claim
   plus its proof. Never open with "I am writing to apply/express my interest".
8. BODY (1–2 paragraphs): the top proof-map rows as claim → evidence with the number → why that
   matters to THIS company's stated need. Mirror the JD's own key terms where they are honest
   synonyms for the user's experience.
9. COMPANY PARAGRAPH (2–3 sentences): one specific, verifiable reason for this company — their
   product, market, stack, or mission, stated concretely. Generic flattery ("industry leader",
   "prestigious company") is banned.
10. CLOSE (1–2 sentences): confident, forward-looking call to action. Sign off matching the
    market's convention.
11. LENGTH: 250–400 words, 3–5 paragraphs, one page, same font family as the CV.
    FORMAT: deliver exactly two files, Firstname_Lastname_Cover_Letter.docx and a text-based
    .pdf converted from it (Word/LibreOffice/docx2pdf). Either is submittable; no .md, .txt, or
    other format ships. A Markdown draft may exist internally but is never handed over.
    PUNCTUATION: NO double dashes in the generated files, not "--" and not an em dash (—) or en
    dash (–) used as a separator. Use a colon to introduce, a semicolon to join clauses, a comma
    for a parenthetical, or a hyphen only inside compound words. Same rationale as ats-cv F10.

DELIVERY MECHANICS: same as ats-cv — build the .docx, convert to a text-based PDF via Word
(docx2pdf) or LibreOffice (soffice --headless --convert-to pdf); confirm the PDF extracts text
before handing it over.

PHASE 3 — VERIFY (no delivery without this):
12. THE SWAP TEST: replace the company name with a competitor's — if the letter still reads
    fine, it FAILS; add JD- and company-specific material until the swap breaks the letter.
    State the verdict in the output.
13. TRACE TEST: every factual claim traces to the CV or a batch answer — cite or cut.
14. VOICE TEST: read it aloud; any sentence the candidate could not say in an interview with a
    straight face gets rewritten. Then run the cliché scan against the BANNED list.
15. DASH SCAN: search the generated text for "--", "—", and "–"; any separator dash is a defect,
    replaced with a colon/semicolon/comma and regenerated. Report the scan result.

OUTPUT: (a) the proof-map table, (b) the DELIVERABLES — exactly two files, one page each:
Firstname_Lastname_Cover_Letter.docx and its text-based .pdf conversion (either is submittable,
no other format ships), (c) NONE-row gaps with the strategy chosen for each, (d) open questions
(e.g. hiring manager's name), (e) the swap-test verdict. Any Markdown draft stays internal.
Offer to regenerate against further JDs — the proof map makes each new letter cheap and honest.
BANNED: "I am writing to apply", "To Whom It May Concern"; "passionate", "team player",
"self-starter", "fast-paced environment", "think outside the box", "dynamic", "synergy",
"wearing many hats"; restating the CV bullet-by-bullet; exceeding one page; inventing facts,
metrics, or company knowledge; flattery without a verifiable specific; a letter that survives
the swap test unchanged; shipping a .md, .txt, or any format other than .docx/.pdf; any double
dash or em/en dash used as separator punctuation in a generated file (use colon/semicolon/comma).

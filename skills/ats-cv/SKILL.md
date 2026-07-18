---
name: ats-cv
description: Use when creating, updating, reviewing, or tailoring a CV/resume for any field or seniority so it survives ATS (Applicant Tracking System) parsing and keyword screening. Forces a parse-integrity audit of any existing CV (text layer, layout, headings, dates), a single batched intake of missing facts (asked, never invented), accomplishment bullets with real metrics, JD keyword mapping when a target role exists, and a plain-text parse simulation before delivery. Delivers the CV as a .docx and a text-based .pdf only (either one is submittable). Composes with cover-letter for the application letter.
---

ROLE: You are building or upgrading a CV that must pass two readers IN ORDER: the ATS parser (a
dumb text extractor and keyword matcher) and the human recruiter (a 6–30 second skim). Optimize
in that order — a beautiful CV whose text the parser cannot extract scores zero before any human
sees it. FABRICATION IS BANNED: every employer, title, date, degree, certification, metric, and
skill in the output must trace to the user's materials or their explicit answers.

PHASE 0 — INTAKE & PARSE AUDIT.
1. Collect what exists: current CV (any format), LinkedIn/profile text, portfolio, target JD if
   there is one. If the CV is a PDF, verify it has a REAL TEXT LAYER by extracting text
   programmatically — scans, images, and vector-outline exports (e.g. print-to-PDF from Google
   Docs or a browser) extract as EMPTY, and hyperlinks lose their URLs. That is a fatal audit
   finding: the CV must be rebuilt from a text source, and every URL re-collected.
2. Audit the existing CV against every ATS RULE below and record a verdict per rule:
   PASS / FAIL + one line of evidence. This table is deliverable (a) — the user should see
   exactly why their current CV fails before seeing the rewrite.
3. THE QUESTION BATCH — collect ALL missing information in ONE batch before writing, never a
   dribble of one-at-a-time questions. Ask ONLY what the materials do not answer, drawn from:
   a. TARGET: role title(s), field, seniority, target market/country — market norms decide
      length, photo, and personal-data conventions (US: no photo/age/marital status; UK/EU:
      2 pages normal; some markets expect a photo — never assume, ask).
   b. NUMBERS: a metric for each major achievement (%, #, $, time saved, scale served — users,
      requests, uptime, revenue, team size). One real number beats three adjectives.
   c. LINKS: exact URLs for LinkedIn, GitHub/portfolio, credential verification — written as
      visible text, since ATS extraction reads text, not hyperlink targets.
   d. GAPS & CHANGES: employment gaps over ~3 months and career changes — decide the honest
      framing with the user, never paper over.
   e. SCOPE CHECKS: any bullet whose ownership is ambiguous ("contributed to X") — confirm what
      the user personally did so the rewrite can claim exactly that, no more, no less.
   If the user is unavailable, build the best truthful version from available material and ship
   the unanswered items as OPEN QUESTIONS in the output — never invent to fill a hole.

PHASE 1 — ATS RULES (hard constraints on the artifact):
   F1  FORMAT: the ONLY delivered file types are .docx and a text-based .pdf — either is
       submittable on its own. No .md, .txt, .rtf, .odt, or image formats in the deliverables
       (a Markdown working draft may exist internally but is never handed over). The .pdf MUST
       be text-based (generated from the .docx via a real converter — Word/LibreOffice/docx2pdf —
       never a print-to-image), verified by re-extraction in Phase 4.
   F2  LAYOUT: single column; no tables, text boxes, columns, or images; contact info in the
       document BODY, never in the header/footer object (many parsers skip those).
   F3  HEADINGS: standard names the parser recognizes — Professional Summary, Work Experience,
       Skills, Projects, Certifications, Education. Clever headings ("My Journey") are banned.
   F4  ORDER & DATES: reverse-chronological; every range as "Mon YYYY – Mon YYYY" or
       "Mon YYYY – Present", one consistent format throughout.
   F5  TYPE: one standard font (Calibri, Arial, Georgia...), 10.5–12pt body; no icons, graphics,
       photos, or emoji (photo only where the target market's norm requires it — per 3a).
   F6  KEYWORDS: critical terms appear in BOTH forms — acronym and spelled out — at least once
       ("Continuous Integration/Continuous Deployment (CI/CD)"), because the ATS matches strings,
       not concepts.
   F7  FILE NAME: Firstname_Lastname_CV.docx (or _Resume per market) — it is a search key in the
       recruiter's inbox.
   F8  NO STUFFING: no white text, no keyword walls, no pasted JD — instant rejection when the
       human reads what the ATS surfaced.
   F9  CONTACT BLOCK: name, city + country, phone with country code, email, URLs as visible text.
   F10 PUNCTUATION: NO double dashes in any generated file — not "--", and not an em dash (—) or
       en dash (–) used as a separator. Replace each with the grammatically correct mark: a
       colon to introduce, a semicolon to join independent clauses, a comma for a parenthetical
       or list, or a hyphen inside a compound word (e.g. "cloud-native"). Ranges use "to" or a
       single hyphen ("Oct 2023 - Present"). Rationale: dash characters are the most common
       source of garbled extraction and inconsistent rendering across ATS parsers, and they read
       as lazy punctuation to a human. This applies to the .docx AND the .pdf.

PHASE 2 — CONTENT DISCIPLINE (what the human reads):
4. SUMMARY: 2–4 lines, written for the target role, leading with the strongest verifiable claim;
   no first person ("I"), no objective statements, no adjective chains.
5. BULLETS: [strong verb] + [what you did] + [quantified outcome]. At least ~60% of bullets in
   the two most recent roles carry a number; a bullet with no possible number states scale or
   frequency instead. Openers "Responsible for", "Contributed to", "Assisted with", "Helped"
   are BANNED — name what the user personally did (per the 3e scope check). 3–6 bullets for
   recent roles, 1–3 for older ones; present tense for the current role, past for previous.
6. LENGTH: 1 page under ~8 years' experience (US/tech norm), 2 pages max otherwise; academic
   CVs are exempt (publications belong there). Cut the oldest, least relevant material first.
7. SKILLS: hard skills, tools, and technologies only, grouped by category; soft skills appear
   as evidence inside bullets ("led 4-person review rotation"), never as a list of adjectives.
8. FIELD NORMS: adapt without breaking F-rules — academic (publications, grants, supervision),
   regulated fields (licence numbers, registrations), creative (this ATS-safe master plus a
   portfolio link; the portfolio carries the visuals), tech (projects with stack named).

PHASE 3 — TAILORING (when a target JD exists):
9. Extract the JD's keywords: exact role title, hard skills, tools, certifications, and repeated
   verbs. Build the COVERAGE TABLE: requirement → where the CV evidences it → verdict
   PRESENT / PRESENT-BUT-WRONG-TERM / MISSING-TRUE / MISSING-NOT-TRUE.
10. PRESENT-BUT-WRONG-TERM → mirror the JD's exact term where it is honestly synonymous (their
    "SQL Server" over your "MSSQL"). MISSING-TRUE → add it from the user's material or the
    question batch. MISSING-NOT-TRUE → NEVER added; it goes to the user as a named gap (a
    cover-letter angle or an upskilling item, not a CV lie).

DELIVERY MECHANICS (how to produce the two files): generate the .docx with a library
(python-docx or equivalent), then convert THAT file to PDF with a real office engine so the PDF
inherits a text layer — on Windows with Word installed, docx2pdf (Word COM) is highest fidelity;
otherwise `soffice --headless --convert-to pdf` (LibreOffice). Only if no office engine exists,
render the .docx faithfully and build the PDF from a text-based library (never an image) — then
Phase 4 must still find a text layer. Never hand over the PDF unopened by the verifier.

PHASE 4 — VERIFY (no delivery without this):
11. PARSE SIMULATION: programmatically extract plain text from BOTH delivered files (the .docx
    AND the .pdf, not your draft) and confirm each: every section present and in order, every
    date parses, contact block intact, no garbled characters. A .pdf that extracts empty or
    garbled is the print-to-image failure from Phase 0 recurring — regenerate it through a real
    converter and re-extract. Paste the extraction summary for both.
12. TEN-SECOND TEST: read only the top third of page 1; name, target role, and the two
    strongest proofs must already be visible.
13. TRUTH TRACE: every line traces to source material or a batch answer; cite or cut.
14. DASH SCAN: search the generated text for "--", "—", and "–". Any hit used as punctuation is
    a defect (F10); replace it with the correct colon/semicolon/comma/hyphen and regenerate.
    Report the scan result (expected: zero separator dashes).

OUTPUT: (a) the audit table (rule → PASS/FAIL → evidence) for any pre-existing CV, (b) the
DELIVERABLES — exactly two files, Firstname_Lastname_CV.docx (generated programmatically, e.g.
python-docx) and Firstname_Lastname_CV.pdf (the same document converted to a text-based PDF via
Word/LibreOffice/docx2pdf); either is submittable and no other file type ships, (c) the JD
coverage table when tailoring, (d) a CHANGELOG of every change and why, (e) OPEN QUESTIONS still
unanswered, (f) the parse-simulation result for both files. Any Markdown draft used to build
them stays internal — it is not a deliverable. When the goal is an application to a specific
job, offer the cover-letter skill next.
BANNED: inventing or inflating any fact; keyword stuffing; tables/columns/graphics/photos in the
ATS artifact; "Responsible for"/"Contributed to" bullet openers; adjectives where the user could
supply a number (ask, don't pad); delivering without the parse simulation; more than 6 bullets
on a single role; asking questions one at a time instead of the single batch; shipping a .md,
.txt, or any format other than .docx/.pdf as a deliverable; a print-to-image PDF with no text
layer; ANY double dash or em/en dash used as separator punctuation in a generated file (F10) —
use a colon, semicolon, or comma.

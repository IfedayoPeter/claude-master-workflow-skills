---
name: product-recon
description: Use when stepping into a new or early-stage project (e.g. "chicktrack") to establish what it is and what it should be. Forces deep ONLINE research of at least 5 comparable real-world projects (with links; code analyzed where public), a feature matrix, then two artifacts - PRD.md with numbered, traceable functional requirements and DataDictionary.md with every entity/field/relationship. If an implementation exists, every requirement is gap-checked against the code as IMPLEMENTED / PARTIAL / MISSING / CONTRADICTED with a ranked gap list.
---

ROLE: You are performing product reconnaissance on a project. Your goal is a PRD and a data
dictionary grounded in (a) what the project actually is and (b) how at least 5 existing
real-world projects in the same space solve the same job — not a template filled with generic
filler. Research means the live web, not memory: your training data is stale and biased toward
famous projects.

PROCEDURE (in this order; each phase's output feeds the next):

PHASE 1 — UNDERSTAND THE PROJECT ITSELF.
1. Determine what the project is about from primary evidence: README, docs, domain entities and
   schema, routes/screens, and the vocabulary of the code (entity names are the domain's nouns).
   Write one sentence: "This project is [category] for [target user] to [job-to-be-done]." If
   there is no code yet, derive it from whatever exists (name, brief, conversations) and mark
   every inference as an assumption to validate against the research in Phase 2.
2. If an implementation exists, run architecture reconnaissance FIRST (arch-recon skill; if
   unavailable, MasterWorkflow prompt 1) — the gap-check in Phase 5 needs a verified model of
   what is actually built, not a skim.

PHASE 2 — COMPARABLE-PROJECT RESEARCH (minimum 5, online, no exceptions).
3. Search the live web from multiple angles: direct competitors, open-source equivalents,
   adjacent-domain tools solving the same job for a different vertical, and domain literature
   ("how X industry tracks Y"). Log every query you run.
4. Select AT LEAST 5 comparables under these rules: at least 2 with publicly available source
   code; at least 1 commercial/closed product; prefer projects with activity in the last ~18
   months; same weight class as the target (comparing a small tracker to SAP is not analysis).
   A comparable you cannot cite a URL for does not count toward the 5.
5. For each comparable record: name, URL(s), what it is, target user, feature list, the data
   concepts it clearly models, deployment/monetization model, and 1–3 things it does notably
   well or badly. For the open-source ones, analyze the ACTUAL code — entities, schema/
   migrations, API surface — with arch-recon discipline; for closed ones use docs, changelogs,
   pricing pages, reviews, and issue/support forums. Feature pages are marketing CLAIMS;
   code, schemas, and issue trackers are evidence — label which tier each fact came from.

PHASE 3 — FEATURE MATRIX.
6. Build a matrix: rows = every capability observed across comparables plus capabilities implied
   by the project's own goal; columns = the comparables + this project. Mark each cell
   HAS / PARTIAL / ABSENT / UNKNOWN. A feature enters the PRD only via this matrix or an
   explicit stakeholder requirement — never by brainstorm.

PHASE 4 — WRITE THE TWO ARTIFACTS.
7. PRD.md, all sections mandatory: Overview & problem statement; Target users & personas;
   Comparable-projects analysis (the full list WITH links, per-project notes, and the feature
   matrix); Functional requirements numbered FR-1..FR-n, each traceable to a matrix row or a
   stated need and each with acceptance criteria; Non-functional requirements (performance,
   security, multi-user/tenancy, offline, compliance — informed by what comparables handle);
   Out of scope (explicit); Open questions.
8. DataDictionary.md: every entity with its purpose; every field with name, type, constraints
   (nullable/unique/range/default), relationships with cardinality, and lifecycle notes (who
   creates/updates/deletes it; soft-delete/audit behavior). Derive from the real schema where
   an implementation exists, otherwise from the comparables' data concepts plus the FRs. Every
   entity must trace to at least one FR — an entity no requirement needs gets flagged, not
   silently included.

PHASE 5 — GAP-CHECK (only when an implementation exists).
9. Cross-check every FR against the code and give a verdict: IMPLEMENTED (cite file/endpoint),
   PARTIAL (state exactly what is missing), MISSING, or CONTRADICTED (the code does something
   different — cite it). No fifth category; "probably implemented" is not a verdict. Verify
   with fact-check discipline; where checking exposes suspected defects or capacity limits,
   run bug-hunt / scalability-audit on that area instead of judging inline.
10. Produce a ranked gap list — missing requirements, improvement areas, changes to be made —
    each entry tied to an FR number and, where relevant, to how a named comparable solves it.

RULES:
- Every comparable in the PRD gets a link. "A popular app does this" without a URL is banned.
- Anything recalled from memory must be re-verified online before it may appear in an artifact.
- If web access is unavailable, STOP and report that — a PRD assembled from memory must never
  be presented as researched.

OUTPUT: (a) PRD.md, (b) DataDictionary.md, (c) if an implementation exists, the FR verdict
table plus the ranked gap list, (d) a research log: every search query and every source
consulted, including dead ends. A PRD whose comparable section contains fewer than 5 linked
projects is invalid — go back to Phase 2.
BANNED: "similar apps typically", "industry standard" or "best practices suggest" without a
cited source, inventing or half-remembering comparables, filling matrix cells from memory
(use UNKNOWN and say what would resolve it).

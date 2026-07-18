# Second Brain — Implementation Plan (Deterministic-Retrieval Edition)

> **Purpose of this document.** This is a build spec detailed enough that a smaller/weaker model
> can execute it end to end without re-deriving the design. It maps a real workspace, builds a
> deterministic (non-LLM) retrieval layer that finds any fact faster and cheaper than default
> Claude Code (`grep`/`glob`), organizes everything under a four-layer model (Applications,
> Routines, Memory, Skills), and renders an optional interactive graph. Every design choice traces
> to the source transcript (VoKiKvgpk78) and to four open-source references: `last30days-skill`
> (Matt Van Horn), `qmd` (Tobi Lütke — hybrid BM25 + vector retrieval), `gbrain` (Garry Tan), and
> `graphify` (Y Combinator — deterministic tree-sitter graph). The visualization is ~30% of the
> value; the deterministic retrieval layer is the other ~70%. Build the retrieval layer first.
>
> **No double dashes anywhere in generated files** — use a colon, semicolon, comma, or a single
> hyphen inside compound words. This applies to every artifact this plan produces.

---

## 0. Scope, root, and success criteria

### 0.1 Workspace root (the thing being mapped)

The brain maps three roots, one per non-skill layer, plus the skills layer:

| Layer | Root path | What lives here |
|---|---|---|
| **Memory** | `C:\Users\Lenovo\source\repos` **and** `C:\Users\Lenovo\Documents` | Code repos, docs, notes, CVs, downloads worth keeping |
| **Skills** | `C:\Users\Lenovo\.claude\skills` | Installed Claude Code skills |
| **Routines** | `C:\Users\Lenovo\.claude` (settings, hooks, scheduled agents) | Hooks, cron/scheduled agents, SessionStart routing |
| **Applications** | derived from connectors/MCP config (see §5) | MCP connectors, CLIs, APIs Claude can drive |

The **brain home** (all generated indexes, code, and views) is a NEW folder that keeps the mapped
roots untouched:

```
C:\Users\Lenovo\SecondBrain\
```

Nothing in this plan writes into `source\repos`, `Documents`, or `.claude` except one optional
convenience hook (§7). The brain is additive and fully removable by deleting `SecondBrain\`.

### 0.2 Acceptance criteria (the build is NOT done until all pass)

1. **A1 Retrieval correctness.** A fixed set of 12 golden questions (§8.1) each return the correct
   source file and section as the top-ranked hit.
2. **A2 Token savings.** On the golden set, the brain path uses **measurably fewer tokens** than a
   default Claude Code session answering the same questions with `grep`/`glob`. Target: **≥ 30%
   fewer** context tokens on average (the transcript observed ~40%). Measured by the A/B harness
   in §8.
3. **A3 Speed.** The brain path returns the answer **faster** on the golden set (wall-clock),
   because scoring is deterministic code, not model calls.
4. **A4 Freshness.** Re-running the indexer after a file changes updates the answer; a stale index
   is a defect.
5. **A5 Visualization (optional gate).** If the graph view is built, it loads in **under 10
   seconds** and every node is clickable to open the underlying file.

If A1 to A4 do not all pass, the brain is not delivering its purpose — fix before shipping.

---

## 1. Architecture overview

```
                          user question
                                │
                                ▼
                    ┌───────────────────────┐
                    │  brain.js  (router)   │   ← deterministic, NO model call
                    │  1 normalize query    │
                    │  2 score candidates    │
                    │  3 open top file only  │
                    │  4 jump to section     │
                    │  5 follow pointers      │
                    └───────────┬───────────┘
                                │ (only the winning section text)
                                ▼
                    ┌───────────────────────┐
                    │  LLM (Claude)         │   ← answers from the ONE section
                    └───────────────────────┘

  built offline by the indexer:
    manifest.json ── index.sqlite (FTS5) ── refmaps/*.json ── graph.json
```

The core idea (straight from the transcript): the model is invoked **only at the end**, on the
single most relevant section, never to search. Searching, scoring, and section-selection are
plain code over pre-built indexes. That is where the token and speed savings come from.

Stack: **Node.js** (the transcript's `brain.js`) with **better-sqlite3** for a local FTS5
full-text index. No cloud calls, no embeddings server required for the baseline (embeddings are an
optional upgrade in §9). Everything runs locally on Windows.

---

## 2. Directory layout to create

```
C:\Users\Lenovo\SecondBrain\
├── brain.js                 # the deterministic router (query → answer-section)
├── indexer.js               # walks roots, builds index.sqlite + refmaps + manifest
├── graph.js                 # builds graph.json + graph.html from the index
├── ab-test.js               # A/B token+speed harness (§8)
├── config.json              # roots, ignore globs, department rules, weights
├── package.json             # deps: better-sqlite3 (required); optional: @xenova/transformers
├── index.sqlite             # GENERATED — FTS5 documents + chunks + metadata
├── manifest.json            # GENERATED — one row per indexed file (path, dept, layer, mtime, hash)
├── refmaps\                 # GENERATED — one JSON reference map per department (the fast path)
│   ├── business.json
│   ├── content.json
│   ├── personal.json
│   └── skills.json
├── departments.json         # human-editable: folder → department mapping + aliases
├── views\
│   ├── graph.html           # GENERATED interactive 4-layer graph
│   └── graph.json           # GENERATED node/edge data
├── golden.json              # 12 golden Q→expected-file/section pairs (§8.1)
└── README.md                # how to query, re-index, and read the graph
```

---

## 3. config.json (author this first)

```json
{
  "brainHome": "C:/Users/Lenovo/SecondBrain",
  "roots": [
    { "path": "C:/Users/Lenovo/source/repos", "layer": "memory" },
    { "path": "C:/Users/Lenovo/Documents",    "layer": "memory" },
    { "path": "C:/Users/Lenovo/.claude/skills", "layer": "skills" },
    { "path": "C:/Users/Lenovo/.claude",        "layer": "routines", "shallow": true }
  ],
  "ignore": [
    "**/node_modules/**", "**/bin/**", "**/obj/**", "**/.git/**",
    "**/dist/**", "**/build/**", "**/.vs/**", "**/*.dll", "**/*.exe",
    "**/packages/**", "**/*.min.*", "**/AppData/**"
  ],
  "indexExtensions": [".md", ".txt", ".cs", ".ts", ".js", ".json", ".py", ".sql", ".yml", ".yaml", ".ps1", ".pdf", ".docx"],
  "chunk": { "targetTokens": 900, "overlapPct": 15 },
  "weights": { "titleHit": 3.0, "headingHit": 2.0, "pathHit": 1.5, "bodyHit": 1.0, "deptHint": 0.5, "recencyDays": 0.01 },
  "maxCandidatesScored": 30,
  "topFilesOpened": 1
}
```

Rationale for the `weights` values: a query term appearing in a file **title** or a **heading** is
a far stronger signal of "the answer lives here" than the same term buried in the body — this is
what lets the router pick the right file **without opening every candidate**. The numbers mirror
`qmd`'s reciprocal-rank-fusion intuition (title/first-rank hits get a bonus) reduced to a simple,
auditable linear score a weaker model can reason about.

---

## 4. The indexer (indexer.js) — build order

Run: `node indexer.js` (full) or `node indexer.js --since <ISO-date>` (incremental).

**Step 4.1 — Walk roots.** For each root, recursively enumerate files, skipping `ignore` globs and
anything not in `indexExtensions`. For `shallow: true` roots, do not descend into `skills/`
(already its own root) or into large state dirs. Record for each file: absolute path, layer,
department (§4.4), `mtime`, and a content SHA-256 `hash` (for incremental re-index and A4
freshness).

**Step 4.2 — Extract text.** Per extension:
- `.md .txt .cs .ts .js .json .py .sql .yml .yaml .ps1` → read as UTF-8 text.
- `.pdf` → extract the **text layer** (use `pdf-parse`; if it extracts empty, flag the file
  `noTextLayer: true` in the manifest — it is unsearchable and must be surfaced, exactly the CV
  failure mode this workspace already hit).
- `.docx` → unzip and read `word/document.xml`, strip tags (or use `mammoth`).

**Step 4.3 — Chunk.** Split each document into ~900-token chunks with 15% overlap, breaking on
semantic boundaries first (headings `^#`, code-fence edges, blank lines) before hard token limits.
Store each chunk with: `docid` (6-char hash of path), `path`, `chunkIndex`, `heading` (nearest
preceding heading), `charStart`, `charEnd`, `text`.

**Step 4.4 — Assign department.** Map each file to a department via `departments.json` (§4.5),
matched by path prefix; unmatched files → `misc`. Department is the coarse pre-filter that narrows
scoring.

**Step 4.5 — departments.json (human-editable).**
```json
{
  "business":  ["source/repos/Educ8e Connector", "source/repos/EdulynkAsdk", "Documents/Business"],
  "content":   ["Documents/Content", "Desktop/pws-Scripts"],
  "personal":  ["Documents/CV_ATS_Case_Study", "Documents/Personal", "Downloads"],
  "skills":    [".claude/skills"],
  "routines":  [".claude/hooks", ".claude/settings.json"],
  "misc":      []
}
```

**Step 4.6 — Write index.sqlite.** Schema:
```sql
CREATE TABLE files (
  path TEXT PRIMARY KEY, layer TEXT, department TEXT,
  title TEXT, mtime INTEGER, hash TEXT, noTextLayer INTEGER DEFAULT 0
);
CREATE TABLE chunks (
  docid TEXT, path TEXT, chunkIndex INTEGER, heading TEXT,
  charStart INTEGER, charEnd INTEGER
);
CREATE VIRTUAL TABLE chunks_fts USING fts5(
  text, path UNINDEXED, heading UNINDEXED, content=''
);
```
Populate `chunks_fts` with BM25-ranked full text; keep `chunks` for offsets so the router can jump
to a section without re-reading the whole file.

**Step 4.7 — Write refmaps (the fast path).** For each department, write `refmaps/<dept>.json`: a
compact map from **keyword → [ {path, heading, score} ]** built from titles and headings ONLY (not
full body). This is the "index and reference map" the transcript describes — it lets the router
score candidate locations for a keyword **without opening any file**. Example:
```json
{
  "tenant isolation": [
    { "path": "source/repos/Educ8e Connector/docs/G3-Tenant-Isolation-Smoke-Test.md", "heading": "G3 — Tenant Data Isolation Smoke Test", "score": 5.0 }
  ],
  "provisioning": [
    { "path": "source/repos/Educ8e Connector/docs/H5-Onboarding-Flow-Smoke-Test.md", "heading": "Step-by-step", "score": 4.0 }
  ]
}
```

**Step 4.8 — Write manifest.json.** One row per file (path, layer, department, title, mtime, hash,
noTextLayer, chunkCount). This is what the graph and the freshness check read.

---

## 5. Applications layer (connectors inventory)

The Applications layer is not a folder walk; it is an inventory of what Claude Code can *drive*.
Build `refmaps/applications.json` from:
- `~/.claude.json` and `~/.claude/settings.json` → MCP servers / connectors.
- `~/.claude/settings.json` `permissions.allow` → CLIs Claude is trusted to run.
- A hand-maintained `applications.json` for API-only tools with no config footprint.

Each application node records: name, kind (`mcp` | `cli` | `api`), scope/risk note (the transcript
stresses this: each connected app is power **and** risk — flag write-capable ones), and last-seen
date. This layer is mostly for the graph and for periodic "should I disconnect this?" review.

---

## 6. brain.js — the deterministic router (the heart)

Run: `node brain.js "which TTS voice do we use"` → prints the winning file, section, and the
section text (which is what a caller hands to the LLM). Algorithm, in order:

1. **Normalize.** Lowercase; strip filler/stopwords (`which`, `do`, `we`, `use`, `the`, `is`,
   `a`, `of`, `how`, `what`); keep the content keywords (`tts voice`). Deterministic — no model.
2. **Department hint (optional).** If a keyword matches a department alias, restrict scoring to
   that department's refmap first; fall back to all departments if no hit.
3. **Score candidates without opening files.** For each keyword, look it up in the refmaps and in
   `chunks_fts` (BM25). Combine into one score per candidate location using `config.weights`
   (title/heading/path/body hits + small recency bonus). Keep the top `maxCandidatesScored` (30).
4. **Open only the top file(s).** Open `topFilesOpened` (default 1) highest-scoring file — NOT the
   whole candidate set.
5. **Jump to the section.** Within that file, use the winning chunk's `heading` + `charStart` to
   read only that section, not the entire file.
6. **Follow pointers.** If the winning section is a pointer (e.g. a Markdown link, a "see X" line,
   or an index row pointing elsewhere), follow it one hop and read the target section. Cap at 3
   hops to prevent loops.
7. **Return** `{ path, heading, sectionText, score, hops }`. The caller (Claude) answers from
   `sectionText` alone.

**Why this saves tokens (A2):** default Claude Code loads whole files via `grep`/`glob` and reads
them into context to find the answer. `brain.js` loads only one section of one file, selected by
deterministic scoring. The model never sees the search space — only the answer's neighborhood.

**Instrumentation (required for A2/A3):** `brain.js` prints, to stderr, `charsReturned`,
`filesOpened`, `candidatesScored`, and `elapsedMs`. The A/B harness reads these.

---

## 7. Optional convenience hook (the only write outside SecondBrain\)

Add a Claude Code skill or a small wrapper so that inside a Claude session you can call
`node C:/Users/Lenovo/SecondBrain/brain.js "<question>"` and have Claude answer from the returned
section. The `2nd-brain-creation` skill (shipped in the master-workflow repo) codifies invoking the
brain before falling back to `grep`/`glob`. No SessionStart hook is required for the brain to work;
it is a plain CLI.

---

## 8. A/B verification harness (proves A1 to A4) — ab-test.js

### 8.1 golden.json — 12 golden questions

Twelve real questions whose answers exist in the mapped workspace, each with the expected source.
Draw them from the actual repos so they are verifiable, e.g.:

```json
[
  { "q": "which branch is canonical for multi-tenancy", "file": "source/repos/Educ8e Connector/docs/BRANCH-COMPARISON-saas-integration-vs-saas-kit-integration.md", "section": "TL;DR" },
  { "q": "how does tid map to a tenant", "file": "source/repos/Educ8e Connector/docs/BRANCH-COMPARISON-saas-integration-vs-saas-kit-integration.md", "section": "How tid → tenant actually works" },
  { "q": "what must fail closed on tenant resolution", "file": "source/repos/Educ8e Connector/docs/G3-Tenant-Isolation-Smoke-Test.md", "section": "Task 3 — No leakage either direction" },
  { "q": "no secret provisioning requirement", "file": "source/repos/Educ8e Connector/docs/H5-Onboarding-Flow-Smoke-Test.md", "section": "Must-confirm (AC)" }
]
```
(Author 8 more spanning skills, CV, and routines so every layer is covered.)

### 8.2 The two paths

- **Brain path:** for each golden Q, run `brain.js`, check the returned `path` equals the expected
  file (A1) and record `charsReturned` + `elapsedMs`.
- **Baseline path:** simulate default retrieval — `grep` the query keywords across the roots, read
  each matching file fully (as Claude Code would to answer), and sum the characters/bytes that
  would enter context. This is the token proxy.

### 8.3 Report (ab-test.js output)

```
GOLDEN SET: 12 questions
A1 correctness:  12/12 top-hit matched expected file   [PASS]
A2 tokens:       brain avg 1,820 chars  vs  baseline avg 9,400 chars   → 80.6% fewer  [PASS ≥30%]
A3 speed:        brain avg 42 ms        vs  baseline avg 310 ms         → 7.4x faster  [PASS]
A4 freshness:    edited file re-indexed; new answer returned            [PASS]
```

Chars are a deterministic, defensible proxy for context tokens (roughly 4 chars/token). If you want
true token counts, wire in a tokenizer; the ratio is what matters for A2. **The build is not done
until this report shows PASS on A1 to A4.**

---

## 9. Optional upgrades (do NOT block the baseline)

- **Semantic layer (qmd-style).** Add local embeddings (`@xenova/transformers`, MiniLM) and a
  `sqlite-vec` vector table; blend vector similarity with BM25 via reciprocal-rank fusion for
  fuzzy queries where keywords miss. Keep the deterministic path as the default; embeddings are a
  fallback when BM25 returns nothing above a threshold.
- **Graph (graphify-style).** `graph.js` reads `manifest.json` + refmaps and emits `graph.json`
  (nodes = files/departments/apps/routines/skills; edges = "in department", "links to", "skill
  uses routine", "app drives skill") and a self-contained `graph.html` (force-directed, four
  colored layers, click-to-open). Gate it on A5 (loads < 10 s). For code repos, tree-sitter can
  add `calls`/`imports` edges, but that is a stretch goal, not the baseline.
- **Departments auto-suggest.** Cluster files by path + shared keywords to propose department
  assignments, then let the user confirm — never auto-commit a department layout.

---

## 10. Build sequence (hand this ordering to the implementing model)

1. Create `SecondBrain\`, `package.json`, install `better-sqlite3` + `pdf-parse` + `mammoth`.
2. Author `config.json` and `departments.json` (§3, §4.5).
3. Build `indexer.js`; run it; confirm `index.sqlite`, `refmaps\*.json`, `manifest.json` exist and
   row counts look sane. Verify at least one `.pdf` extracts a text layer and any that do not are
   flagged `noTextLayer`.
4. Build `brain.js`; smoke-test 3 questions by hand.
5. Author `golden.json` (12 questions across all four layers).
6. Build `ab-test.js`; run it; iterate on `config.weights` until A1 to A4 all PASS.
7. (Optional) Build `graph.js`; confirm A5 (< 10 s load, click-to-open).
8. Write `SecondBrain\README.md`: how to query, re-index (`node indexer.js`), and read the graph.
9. Report the A/B numbers back to the user as the definition of done.

---

## 11. Definition of done (report these, do not hand-wave)

- [ ] `SecondBrain\` exists with indexer, brain, config, index.sqlite, refmaps, manifest.
- [ ] A1 correctness PASS (12/12 golden top-hits correct).
- [ ] A2 tokens PASS (≥ 30% fewer chars/tokens than baseline, number stated).
- [ ] A3 speed PASS (faster than baseline, number stated).
- [ ] A4 freshness PASS (edit → re-index → new answer).
- [ ] Any `.pdf` with no text layer is surfaced, not silently dropped.
- [ ] (If built) A5 graph loads < 10 s, nodes click-to-open.
- [ ] No double dashes in any generated file.

Banned outcomes: declaring done without the A/B numbers; a graph with no retrieval layer behind it
("just for show"); an indexer that reads whole files at query time (defeats the token goal); silent
handling of unsearchable PDFs.

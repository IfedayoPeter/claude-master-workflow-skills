---
name: 2nd-brain-creation
description: Use when building a "second brain" over a user's workspace, or asked to make Claude find files/facts faster and cheaper across their folders, notes, repos, and skills. Builds a deterministic (non-LLM) retrieval layer — an offline index plus reference maps plus a router that scores candidate files WITHOUT opening them, opens only the top file, and jumps to the one relevant section — organized under a four-layer model (Applications, Routines, Memory, Skills), with an optional interactive graph. The retrieval layer is the point (faster + fewer tokens than grep/glob); the graph is secondary. Refuses to declare done without a measured A/B token-and-speed win versus baseline retrieval.
---

ROLE: You are building a second brain whose PURPOSE is measurable, not decorative: Claude must
retrieve any fact from the workspace FASTER and at LOWER token cost than default retrieval
(grep/glob reading whole files into context). The visualization is at most ~30% of the value; the
deterministic retrieval layer is the other ~70%, so build retrieval FIRST and prove it. The model
is invoked only at the very end, on the single winning section — never to search. Searching,
scoring, and section-selection are plain deterministic code over pre-built indexes. NO double
dashes in any generated file: use a colon, semicolon, comma, or a hyphen inside a compound word.

PHASE 0 — SCOPE & ROOT (ask, do not assume).
1. Establish the WORKSPACE ROOT(S) to map and the four-layer assignment:
   - MEMORY: the folders holding the user's files, notes, code, documents.
   - SKILLS: the installed-skills directory.
   - ROUTINES: hooks, scheduled/cron agents, session config.
   - APPLICATIONS: the MCP connectors, CLIs, and APIs Claude can drive (from connector/settings
     config, not a folder walk).
   If the session launch directory is not the workspace (e.g. a shell default), ASK for the real
   root(s) — a brain mapped to the wrong root is worthless. State the assumed root explicitly if
   the user is unavailable.
2. Pick a BRAIN HOME that is a NEW folder, so the mapped roots stay untouched and the whole brain
   is removable by deleting one directory. Nothing writes into the mapped roots except one
   optional convenience hook, and only with the user's ok.

PHASE 1 — CONFIG (author before any indexing).
3. Write a config that pins: roots (each tagged with its layer), ignore globs (node_modules, bin,
   obj, .git, dist, build, packages, minified, binaries), indexed extensions, chunk size
   (~900 tokens, ~15% overlap, break on headings/code-fences/blank lines first), scoring weights
   (title hit > heading hit > path hit > body hit, plus a small recency bonus), max candidates
   scored (~30), and files opened at query time (default 1).
4. Write a human-editable department map: folder-prefix → department (business, content, personal,
   skills, routines, misc). Departments are the coarse pre-filter that narrows scoring. Never
   auto-commit a department layout the user has not seen.

PHASE 2 — INDEXER (offline build).
5. Walk the roots (honoring ignore globs and extensions); for each file record path, layer,
   department, mtime, and a content hash (for incremental re-index and freshness).
6. Extract text per type. For PDFs, extract the TEXT LAYER; if it extracts EMPTY, flag the file
   unsearchable and SURFACE it — never silently drop it (a vector-outline/print-to-image PDF is
   invisible to search, the exact failure a real workspace already hit). For .docx, read the
   document XML.
7. Chunk each document on semantic boundaries; store per chunk: a short docid, path, chunk index,
   nearest preceding heading, char offsets, and text.
8. Build the store: a local full-text index (SQLite FTS5 / BM25 or equivalent) over chunks, plus a
   manifest (one row per file). THEN build REFERENCE MAPS: per department, a compact
   keyword → [{path, heading, score}] map built from TITLES AND HEADINGS ONLY. The reference maps
   are the fast path — they let the router score candidate locations for a keyword WITHOUT opening
   any file.
9. Build the APPLICATIONS inventory from connector/settings config: each app tagged kind
   (mcp/cli/api) and a risk note (write-capable connectors are power and risk — flag them for the
   periodic "should I disconnect this?" review).

PHASE 3 — ROUTER (the deterministic heart — no model call inside it).
10. Implement the query router as plain code, in this order:
    a. NORMALIZE: lowercase, strip filler/stopwords, keep content keywords.
    b. DEPARTMENT HINT: if a keyword matches a department alias, score that department first;
       fall back to all departments on a miss.
    c. SCORE WITHOUT OPENING: for each keyword, look it up in the reference maps and the full-text
       index; combine into one score per candidate location using the config weights. Keep the top
       ~30 candidates. No files are opened in this step.
    d. OPEN ONLY THE TOP FILE(S): open just the highest-scoring file (default 1), not the candidate
       set.
    e. JUMP TO THE SECTION: read only the winning chunk's section (heading + offsets), not the
       whole file.
    f. FOLLOW POINTERS: if the section points elsewhere (a link, a "see X", an index row), follow
       one hop and read the target section; cap at 3 hops to prevent loops.
    g. RETURN {path, heading, sectionText, score, hops}; the model answers from sectionText alone.
11. INSTRUMENT the router: it must emit charsReturned, filesOpened, candidatesScored, and elapsedMs
    so the A/B harness can measure the savings. A router that reads whole files at query time
    defeats the token goal and is a defect.

PHASE 4 — PROVE IT (no "done" without these numbers).
12. Author a GOLDEN SET of at least 12 real questions whose answers exist in the mapped workspace,
    each with the expected source file and section, spanning all four layers.
13. Run an A/B harness:
    - BRAIN path: run the router per question; check the top-hit file equals expected (correctness)
      and record charsReturned + elapsedMs.
    - BASELINE path: grep the keywords across roots, sum the characters of every file that would be
      read fully into context (the token proxy), and time it.
14. Report the table and gate on it:
    - A1 CORRECTNESS: top hit matches expected file for every golden question.
    - A2 TOKENS: brain uses measurably fewer chars/tokens than baseline — target ≥ 30% fewer,
      state the number.
    - A3 SPEED: brain is faster than baseline, state the number.
    - A4 FRESHNESS: edit a file, re-index, confirm the answer updates.
    Iterate the scoring weights until A1 to A4 all PASS. Chars are a defensible token proxy
    (~4 chars/token); wire a real tokenizer only if the user wants exact counts.

PHASE 5 — VISUALIZATION (optional, gated).
15. Only after retrieval passes, optionally build an interactive graph: nodes = files / departments
    / apps / routines / skills; edges = "in department", "links to", "skill uses routine", "app
    drives skill". It must be a self-contained HTML file, four visually distinct layers, every node
    click-to-open. GATE A5: it loads in under 10 seconds; keep optimizing until it does. A graph
    with no retrieval layer behind it ("just for show") is banned.

PHASE 6 — HAND-OFF.
16. Write a brain README: how to query, how to re-index (full and incremental), and how to read the
    graph. Offer the optional convenience wrapper so a Claude session calls the router before
    falling back to grep/glob.

OUTPUT: (a) the config + department map, (b) the built index + reference maps + manifest with row
counts, (c) the router with its instrumentation, (d) the golden set, (e) the A/B report showing
A1 to A4 PASS with stated token and speed numbers — this is the definition of done, (f) any
unsearchable PDFs surfaced, (g) optionally the graph passing A5, (h) the brain README. If a
detailed workspace plan already exists (e.g. a SecondBrain implementation plan), follow it and
report against its acceptance criteria.
BANNED: declaring the brain done without the measured A/B token-and-speed numbers; a router that
reads whole files at query time (defeats the purpose); building the graph before the retrieval
layer works; a graph "just for show" with no retrieval behind it; silently dropping PDFs with no
text layer instead of surfacing them; auto-committing a department layout the user has not
approved; writing into the mapped roots beyond one approved convenience hook; ANY double dash or
em/en dash used as separator punctuation in a generated file — use a colon, semicolon, or comma.

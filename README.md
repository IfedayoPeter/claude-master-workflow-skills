# Master Workflow Skills for Claude Code

Nineteen skills: eighteen discipline skills that force rigorous engineering, career, and
document discipline — verified architecture maps, adversarial bug and security hunts,
measure-first performance work, behavior-preserving refactors, test-first implementation,
researched PRDs with Azure DevOps-importable backlogs, design-first frontends with
user-approved mockups, disciplined vibe-coding, honest verification reporting, ATS-verified
CVs, swap-tested cover letters, evidence-backed interview prep, and recruiter-optimized
LinkedIn profiles — plus `master-workflow`, the router
that dispatches tasks to the right skill, chains them into pipelines, and enforces the
user-approval gates between them. They were written so smaller/faster models produce work closer to a
frontier model's, but they sharpen any model.

Each skill is a forced procedure with a required output format and **banned phrases** ("should
work", "looks good", "tests to follow"). The format is the load-bearing part: it makes shallow
work visibly incomplete rather than just discouraged.

## The 19 skills

| Skill | Use when |
|---|---|
| `arch-recon` | Entering an unfamiliar codebase; mapping/auditing architecture (persists an `Architecture.md`) |
| `bug-hunt` | Hunting bugs, auditing correctness, finding silent defects (findings ranked by severity) |
| `security-audit` | Security review/hardening of your own system: auth, authz/IDOR, injection, secrets, crypto, SSRF, uploads, tenancy — every finding an exploit scenario + severity |
| `scalability-audit` | Assessing whether something scales at 10x; capacity/bottleneck analysis from reading the code |
| `perf-profile` | Making correct code faster / "why is this slow": benchmark + profile a real workload, before/after numbers per change |
| `fix-design` | Designing/implementing a fix for a known, identified defect |
| `refactor-safe` | Restructuring code without changing behavior: characterization test first, small reversible steps, structure-only diff |
| `durability-check` | After a code change, before committing or declaring it done |
| `fact-check` | Verifying a claim: doc-vs-code, config defaults, numbers/thresholds |
| `ui-excellence` | Designing or building any UI: a named design direction + signature element before any code (generic admin-template output is an automatic fail), craft system, depth/3D and motion choreography, state matrix, and a scored critique loop (ship at ≥8/10 craft AND boldness) |
| `ui-design-preview` | Before implementing any frontend with 3+ screens: Figma-style design phase — one static HTML mockup per screen + an index gallery viewable by double-click, and/or a prompt pack for AI design tools (Claude, v0, Figma Make, Lovable); hard user-approval gate before FE code |
| `test-first` | **Before** implementing any new code — the test is written and observed to FAIL before the first line of implementation exists |
| `product-recon` | Stepping into a new/early-stage project: live-web research of ≥5 linked comparable projects, a feature matrix, PRD.md + DataDictionary.md + an Azure DevOps-importable backlog (Backlog.md + CSV), and an FR-by-FR gap-check against any existing implementation |
| `vibe-build` | Implementing a product from a PRD/spec: user-confirmed stack + an explicit mobile-companion question, a design-preview gate before multi-screen frontends, vertical slices from a walking skeleton that includes an in-app `/docs` page updated every slice, an auth on/off toggle for testable security, run-it-like-a-user verification per slice, three-strikes revert rule, final FR-by-FR gap-check — distilled from the instruction sets of Lovable, Bolt, Cursor, Kiro, and GitHub Spec Kit |
| `ats-cv` | Creating, updating, reviewing, or tailoring a CV/resume for any field to ATS standards: parse-integrity audit of the existing CV (text layer, layout, headings, dates), ONE batched intake of missing facts (asked, never invented), metric-carrying accomplishment bullets, JD keyword coverage when targeting a role, and a programmatic plain-text parse simulation — delivered as a `.docx` + text-based `.pdf` only (either one applies) |
| `cover-letter` | Writing a cover letter for a specific job from the JD + the CV: ranked must-have extraction, a proof map backing every claim with a CV fact, honest handling of missing requirements, a banned-cliché scan, and the swap test — a letter that could be sent to a different company unchanged fails; delivered as a `.docx` + `.pdf` only |
| `interview-prep` | Preparing for a specific interview from the JD + CV: ranked predicted questions (technical + behavioral), a STAR answer bank built only from real experience, honest gap-defense scripts, researched questions to ask, and a mock-exchange critique of the weak spots |
| `linkedin-optimizer` | Turning a CV into an optimized LinkedIn profile: recruiter-search keyword map, first-person Headline/About/Experience rewritten to LinkedIn conventions and limits, ordered Skills, and a discoverability/settings checklist — same no-fabrication rule as `ats-cv` |
| `master-workflow` | The router: dispatch table + tie-breakers deciding which skill fits, the canonical chains (greenfield, existing project, bug report, performance, security, refactor, claim audit, job application), user-approval gates, and composition rules |

## Install

Every install path sets up two things: the **19 skills**, and a **SessionStart hook** that
injects the mandatory routing rules into every session — so Claude routes tasks through the
skills automatically instead of waiting to be told.

### Option A — Plugin (recommended: one command, hook auto-configured)

Inside Claude Code:

```
/plugin marketplace add IfedayoPeter/claude-master-workflow-skills
/plugin install master-workflow-skills@master-workflow-skills
```

Installing the plugin loads all 19 skills AND activates the SessionStart routing hook — no
settings editing, and uninstalling the plugin cleanly removes both.

### Option B — Install script (copies skills + merges the hook into your settings)

macOS / Linux:

```bash
git clone https://github.com/IfedayoPeter/claude-master-workflow-skills.git
cd claude-master-workflow-skills && ./install.sh
```

Windows (PowerShell):

```powershell
git clone https://github.com/IfedayoPeter/claude-master-workflow-skills.git
cd claude-master-workflow-skills; .\install.ps1
```

The script copies the skills to `~/.claude/skills/`, the hook payload to `~/.claude/hooks/`,
and merges the SessionStart hook into `~/.claude/settings.json` (idempotent — safe to re-run
after a `git pull` to update).

### Option C — Manual copy (skills only, no hook)

Copy the `skills/*` folders into `~/.claude/skills/` (personal) or
`<project>/.claude/skills/` (shared with your team via the repo). Without the hook, skills
still trigger by description matching and `/<skill-name>` — just less reliably; see
"Make them mandatory" below.

Restart Claude Code (or start a new session) and the skills appear in the available-skills list.
Invoke one explicitly with `/<skill-name>` (e.g. `/test-first`), or let Claude match them by task
shape.

## Make them mandatory (belt-and-suspenders)

Options A and B already enforce routing via the SessionStart hook. For extra reinforcement —
or if you installed via manual copy — add this to your project's `CLAUDE.md` (or
`~/.claude/CLAUDE.md` for all projects):

```markdown
## Mandatory Skill Usage

When a task matches one of the 19 domains below, invoking the matching skill is **compulsory** —
do not work from memory/guessing on these task types. Match by task shape, not just by the user
literally naming the skill. When unsure which skill fits, or a task spans several, invoke
`master-workflow` first — it routes, chains, and defines the approval gates.

| Task shape | Skill to invoke |
|---|---|
| Entering/mapping an unfamiliar area of the codebase, understanding architecture | `arch-recon` |
| Hunting bugs, auditing correctness, finding lapses/flaws/silent defects | `bug-hunt` |
| Security review/hardening of your own system (auth, injection, secrets, tenancy) | `security-audit` |
| Assessing whether something scales at 10x, capacity/bottleneck analysis | `scalability-audit` |
| Making already-correct code faster, "why is this slow" on a real workload | `perf-profile` |
| Designing/implementing a fix for a known, already-identified defect | `fix-design` |
| Restructuring code without changing behavior (rename/extract/dedupe/move) | `refactor-safe` |
| After making a code change, before committing or declaring it done | `durability-check` |
| Verifying a claim, doc-vs-code check, validating a number/threshold | `fact-check` |
| Designing or building any UI (screens, components, styling, layout) | `ui-excellence` |
| About to implement a frontend with 3+ screens, or the user wants to see designs/mockups/design-tool prompts before code | `ui-design-preview` |
| Implementing any new code (feature, behavior, bug fix) — invoke BEFORE the first line is written | `test-first` |
| Stepping into a new/early-stage project: online research of ≥5 comparables, PRD + data dictionary, gap-check vs implementation | `product-recon` |
| Implementing a product from a PRD/spec (greenfield build or major feature wave) in verified vertical slices | `vibe-build` |
| Creating, updating, or tailoring a CV/resume (any field) to ATS standards | `ats-cv` |
| Writing a cover letter for a specific job from a JD + CV | `cover-letter` |
| Preparing for a specific interview from a JD + CV | `interview-prep` |
| Turning a CV into an optimized LinkedIn profile | `linkedin-optimizer` |
| Unsure which skill fits, several apply, or a full pipeline is starting (research → build → verify) | `master-workflow` |
```

## Using them outside Claude Code

[`MasterWorkflow.md`](MasterWorkflow.md) contains the same procedures as self-contained prompts,
written to be pasted verbatim into any model's system prompt or prepended to a task — plain API
calls, other agent harnesses, other tools. Use one at a time (matched to the task); combining
more than two dilutes compliance.

## Usage notes

1. **The output-format and banned-phrase clauses are the load-bearing parts.** Models comply far
   better with "every finding must include a concrete failing input" than with "be thorough". If
   you trim for token budget, cut prose before you cut the OUTPUT/BANNED sections.
2. **These raise discipline, not capability.** They stop a model from sweet-talking you and force
   it to show its evidence — which also makes its *failures* visible (you'll see "UNVERIFIABLE"
   and thin failure scenarios instead of false assurance). That visibility is the real upgrade:
   you'll know when to distrust the answer.

## License

[MIT](LICENSE)

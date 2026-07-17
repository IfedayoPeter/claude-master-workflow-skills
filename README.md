# Master Workflow Skills for Claude Code

Twelve skills: eleven discipline skills that force rigorous engineering behavior — verified
architecture maps, adversarial bug hunts, test-first implementation, researched PRDs with
Azure DevOps-importable backlogs, design-first frontends with user-approved mockups,
disciplined vibe-coding, honest verification reporting — plus `master-workflow`, the router
that dispatches tasks to the right skill, chains them into pipelines, and enforces the
user-approval gates between them. They were written so smaller/faster models produce work closer to a
frontier model's, but they sharpen any model.

Each skill is a forced procedure with a required output format and **banned phrases** ("should
work", "looks good", "tests to follow"). The format is the load-bearing part: it makes shallow
work visibly incomplete rather than just discouraged.

## The 12 skills

| Skill | Use when |
|---|---|
| `arch-recon` | Entering an unfamiliar codebase; mapping/auditing architecture |
| `bug-hunt` | Hunting bugs, auditing correctness, finding silent defects |
| `scalability-audit` | Assessing whether something scales; capacity/bottleneck analysis |
| `fix-design` | Designing/implementing a fix for a known, identified defect |
| `durability-check` | After a code change, before committing or declaring it done |
| `fact-check` | Verifying a claim: doc-vs-code, config defaults, numbers/thresholds |
| `ui-excellence` | Designing or building any UI: a named design direction + signature element before any code (generic admin-template output is an automatic fail), craft system, depth/3D and motion choreography, state matrix, and a scored critique loop (ship at ≥8/10 craft AND boldness) |
| `ui-design-preview` | Before implementing any frontend with 3+ screens: Figma-style design phase — one static HTML mockup per screen + an index gallery viewable by double-click, and/or a prompt pack for AI design tools (Claude, v0, Figma Make, Lovable); hard user-approval gate before FE code |
| `test-first` | **Before** implementing any new code — the test is written and observed to FAIL before the first line of implementation exists |
| `product-recon` | Stepping into a new/early-stage project: live-web research of ≥5 linked comparable projects, a feature matrix, PRD.md + DataDictionary.md + an Azure DevOps-importable backlog (Backlog.md + CSV), and an FR-by-FR gap-check against any existing implementation |
| `vibe-build` | Implementing a product from a PRD/spec: user-confirmed stack + an explicit mobile-companion question, a design-preview gate before multi-screen frontends, vertical slices from a walking skeleton that includes an in-app `/docs` page updated every slice, an auth on/off toggle for testable security, run-it-like-a-user verification per slice, three-strikes revert rule, final FR-by-FR gap-check — distilled from the instruction sets of Lovable, Bolt, Cursor, Kiro, and GitHub Spec Kit |
| `master-workflow` | The router: dispatch table + tie-breakers deciding which skill fits, the canonical chains (greenfield, existing project, bug report, performance, claim audit), user-approval gates, and composition rules |

## Install

Each skill is a folder containing a single `SKILL.md`. Copy the folders into a skills directory
Claude Code scans:

- **Personal (all your projects):** `~/.claude/skills/`
- **Per project (shared with your team via the repo):** `<project>/.claude/skills/`

### macOS / Linux

```bash
git clone https://github.com/IfedayoPeter/claude-master-workflow-skills.git
cp -r claude-master-workflow-skills/skills/* ~/.claude/skills/
```

### Windows (PowerShell)

```powershell
git clone https://github.com/IfedayoPeter/claude-master-workflow-skills.git
New-Item -ItemType Directory -Force "$HOME\.claude\skills" | Out-Null
Copy-Item -Recurse -Force claude-master-workflow-skills\skills\* "$HOME\.claude\skills\"
```

Restart Claude Code (or start a new session) and the skills appear in the available-skills list.
Invoke one explicitly with `/<skill-name>` (e.g. `/test-first`), or let Claude match them by task
shape.

## Make them mandatory (recommended)

Skills trigger far more reliably when your project's `CLAUDE.md` makes them compulsory. Add:

```markdown
## Mandatory Skill Usage

When a task matches one of the 12 domains below, invoking the matching skill is **compulsory** —
do not work from memory/guessing on these task types. Match by task shape, not just by the user
literally naming the skill. When unsure which skill fits, or a task spans several, invoke
`master-workflow` first — it routes, chains, and defines the approval gates.

| Task shape | Skill to invoke |
|---|---|
| Entering/mapping an unfamiliar area of the codebase, understanding architecture | `arch-recon` |
| Hunting bugs, auditing correctness, finding lapses/flaws/silent defects | `bug-hunt` |
| Assessing whether something scales, capacity/bottleneck analysis | `scalability-audit` |
| Designing/implementing a fix for a known, already-identified defect | `fix-design` |
| After making a code change, before committing or declaring it done | `durability-check` |
| Verifying a claim, doc-vs-code check, validating a number/threshold | `fact-check` |
| Designing or building any UI (screens, components, styling, layout) | `ui-excellence` |
| About to implement a frontend with 3+ screens, or the user wants to see designs/mockups/design-tool prompts before code | `ui-design-preview` |
| Implementing any new code (feature, behavior, bug fix) — invoke BEFORE the first line is written | `test-first` |
| Stepping into a new/early-stage project: online research of ≥5 comparables, PRD + data dictionary, gap-check vs implementation | `product-recon` |
| Implementing a product from a PRD/spec (greenfield build or major feature wave) in verified vertical slices | `vibe-build` |
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

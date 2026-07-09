# Master Workflow Skills for Claude Code

Nine discipline skills that force rigorous engineering behavior — verified architecture maps,
adversarial bug hunts, test-first implementation, researched PRDs, honest verification
reporting — instead of plausible-sounding shortcuts. They were written so smaller/faster models produce work closer to a
frontier model's, but they sharpen any model.

Each skill is a forced procedure with a required output format and **banned phrases** ("should
work", "looks good", "tests to follow"). The format is the load-bearing part: it makes shallow
work visibly incomplete rather than just discouraged.

## The 9 skills

| Skill | Use when |
|---|---|
| `arch-recon` | Entering an unfamiliar codebase; mapping/auditing architecture |
| `bug-hunt` | Hunting bugs, auditing correctness, finding silent defects |
| `scalability-audit` | Assessing whether something scales; capacity/bottleneck analysis |
| `fix-design` | Designing/implementing a fix for a known, identified defect |
| `durability-check` | After a code change, before committing or declaring it done |
| `fact-check` | Verifying a claim: doc-vs-code, config defaults, numbers/thresholds |
| `ui-excellence` | Designing or building any UI (screens, components, styling, layout) |
| `test-first` | **Before** implementing any new code — the test is written and observed to FAIL before the first line of implementation exists |
| `product-recon` | Stepping into a new/early-stage project: live-web research of ≥5 linked comparable projects, a feature matrix, PRD.md + DataDictionary.md, and an FR-by-FR gap-check against any existing implementation |

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

When a task matches one of the 9 domains below, invoking the matching skill is **compulsory** —
do not work from memory/guessing on these task types. Match by task shape, not just by the user
literally naming the skill.

| Task shape | Skill to invoke |
|---|---|
| Entering/mapping an unfamiliar area of the codebase, understanding architecture | `arch-recon` |
| Hunting bugs, auditing correctness, finding lapses/flaws/silent defects | `bug-hunt` |
| Assessing whether something scales, capacity/bottleneck analysis | `scalability-audit` |
| Designing/implementing a fix for a known, already-identified defect | `fix-design` |
| After making a code change, before committing or declaring it done | `durability-check` |
| Verifying a claim, doc-vs-code check, validating a number/threshold | `fact-check` |
| Designing or building any UI (screens, components, styling, layout) | `ui-excellence` |
| Implementing any new code (feature, behavior, bug fix) — invoke BEFORE the first line is written | `test-first` |
| Stepping into a new/early-stage project: online research of ≥5 comparables, PRD + data dictionary, gap-check vs implementation | `product-recon` |
```

## Using them outside Claude Code

[`MasterWorkflow.md`](MasterWorkflow.md) contains the same 8 procedures as self-contained prompts,
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

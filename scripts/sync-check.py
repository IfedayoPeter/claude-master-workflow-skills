#!/usr/bin/env python3
"""Consistency check for the master-workflow-skills repo.

Every skill under skills/ must be registered in each of the places that reference the skill
set, or the SessionStart routing hook and the docs drift out of agreement with what is actually
installed. Run this before committing a skill addition/rename:

    python scripts/sync-check.py

Exit code 0 = everything agrees; 1 = at least one drift reported (suitable for a pre-commit
hook or CI). No third-party dependencies — standard library only.
"""
import json
import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
SKILLS_DIR = REPO / "skills"

problems = []


def note(msg):
    problems.append(msg)


def skill_names():
    names = []
    for d in sorted(SKILLS_DIR.iterdir()):
        if not d.is_dir():
            continue
        skill_md = d / "SKILL.md"
        if not skill_md.exists():
            note(f"skills/{d.name}/ has no SKILL.md")
            continue
        text = skill_md.read_text(encoding="utf-8")
        m = re.search(r"^name:\s*(.+)$", text, re.MULTILINE)
        fm_name = m.group(1).strip() if m else None
        if fm_name != d.name:
            note(f"skills/{d.name}/SKILL.md frontmatter name is {fm_name!r}, expected {d.name!r}")
        if "description:" not in text:
            note(f"skills/{d.name}/SKILL.md has no description in frontmatter")
        names.append(d.name)
    return names


def check_contains(path: Path, needles, label):
    if not path.exists():
        note(f"{label}: file missing ({path})")
        return
    text = path.read_text(encoding="utf-8")
    for n in needles:
        if n not in text:
            note(f"{label}: missing reference to skill '{n}'")


# MasterWorkflow.md refers to skills by "<prompt-number> <short-name>" inside its router prompt
# and by short name in prose (e.g. "3 scalability", "5 durability", prompt 7 = ui), not always by
# the full folder slug. Accept any of a skill's known aliases as a valid reference there.
ALIASES = {
    "scalability-audit": ["scalability-audit", "scalability"],
    "durability-check": ["durability-check", "durability"],
    "ui-excellence": ["ui-excellence", "ui-excellence", "prompt 7", " 7 ui", "UI Excellence"],
    "fix-design": ["fix-design", "fix-design"],
}


def check_count(path: Path, expected, label, use_aliases=False):
    """Every skill folder is expected; the router is allowed to omit its OWN name from its
    dispatch table, so we check each non-router skill is present rather than a raw count.
    With use_aliases, a skill counts as referenced if any of its aliases appears (for
    MasterWorkflow.md's number+short-name style)."""
    if not path.exists():
        note(f"{label}: file missing ({path})")
        return
    text = path.read_text(encoding="utf-8")
    for n in expected:
        if n == "master-workflow":
            continue
        candidates = ALIASES.get(n, [n]) if use_aliases else [n]
        if not any(c in text for c in candidates):
            note(f"{label}: missing reference to skill '{n}'")


def main():
    names = skill_names()
    n = len(names)
    print(f"Found {n} skills: {', '.join(names)}")

    # The router SKILL.md must reference every other skill in its dispatch/tie-breaker text.
    check_count(SKILLS_DIR / "master-workflow" / "SKILL.md", names,
                "skills/master-workflow/SKILL.md")

    # README: dispatch table + mandatory-usage table both must list each skill.
    check_count(REPO / "README.md", names, "README.md")

    # MasterWorkflow.md: the pasteable router prompt references every skill (by number + short
    # name in the router, so aliases are accepted). ats-cv / cover-letter appear by full slug.
    check_count(REPO / "MasterWorkflow.md", names, "MasterWorkflow.md", use_aliases=True)

    # The SessionStart hook payload routes to each skill.
    hook = REPO / "hooks" / "master-workflow-reminder.json"
    check_count(hook, names, "hooks/master-workflow-reminder.json")
    if hook.exists():
        try:
            json.loads(hook.read_text(encoding="utf-8"))
        except json.JSONDecodeError as e:
            note(f"hooks/master-workflow-reminder.json is not valid JSON: {e}")

    # Plugin manifests must be valid JSON.
    for man in [REPO / ".claude-plugin" / "plugin.json",
                REPO / ".claude-plugin" / "marketplace.json"]:
        if man.exists():
            try:
                json.loads(man.read_text(encoding="utf-8"))
            except json.JSONDecodeError as e:
                note(f"{man.relative_to(REPO)} is not valid JSON: {e}")
        else:
            note(f"{man.relative_to(REPO)} missing")

    print()
    if problems:
        print(f"SYNC-CHECK FAILED — {len(problems)} issue(s):")
        for p in problems:
            print(f"  - {p}")
        return 1
    print(f"SYNC-CHECK PASSED — all {n} skills registered across router, README, "
          f"MasterWorkflow.md, hook, and plugin manifests are valid JSON.")
    return 0


if __name__ == "__main__":
    sys.exit(main())

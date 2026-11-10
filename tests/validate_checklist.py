#!/usr/bin/env python3
"""Check that checklist.yml keeps the shape its header comment promises:
every item has id, task, why, check, automate and cadence; cadence is one of
the four documented values; ids are unique (tooling refers to them).
Needs PyYAML. Usage: python3 tests/validate_checklist.py [checklist.yml]"""
import sys

import yaml

CADENCES = {"continuous", "weekly", "monthly", "quarterly"}
ITEM_KEYS = ("id", "task", "why", "check", "automate", "cadence")

path = sys.argv[1] if len(sys.argv) > 1 else "checklist.yml"
with open(path, encoding="utf-8") as fh:
    data = yaml.safe_load(fh)

errors = []
for key in ("version", "license", "maintainer", "sections"):
    if key not in data:
        errors.append(f"missing top-level key: {key}")

seen = set()
count = 0
for s_index, section in enumerate(data.get("sections") or []):
    sid = section.get("id")
    if not sid or not section.get("title"):
        errors.append(f"section {s_index} needs an id and a title")
    items = section.get("items") or []
    if not items:
        errors.append(f"section {sid!r} has no items")
    for item in items:
        count += 1
        iid = item.get("id", f"<item {count}>")
        for key in ITEM_KEYS:
            if not str(item.get(key, "")).strip():
                errors.append(f"{iid}: missing or empty {key}")
        if item.get("cadence") not in CADENCES:
            errors.append(f"{iid}: cadence {item.get('cadence')!r} is not one of {sorted(CADENCES)}")
        if iid in seen:
            errors.append(f"{iid}: duplicate id")
        seen.add(iid)

if errors:
    print(f"{path}: {len(errors)} problem(s)")
    for e in errors:
        print("  - " + e)
    sys.exit(1)
print(f"{path} OK: {len(data['sections'])} sections, {count} items")

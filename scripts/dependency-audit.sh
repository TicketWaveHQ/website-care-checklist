#!/usr/bin/env bash
#
# dependency-audit.sh - detect the package manager(s) in a project and run the
# right vulnerability audit for each. Covers the stacks a small business site
# usually runs on: Node, PHP/Composer, Python, and Ruby.
#
# Usage:
#   ./dependency-audit.sh [path]     # defaults to the current directory
#
# It runs every audit whose manifest it finds, and exits non-zero if any of
# them report vulnerabilities, so it can gate CI.
#
# Part of the Website Care Checklist by UK Web Marketing
# (https://ukwebmarketing.com), CC BY 4.0.

set -uo pipefail

ROOT="${1:-.}"
cd "$ROOT"

ran=0
failed=0

run() {
  # run <label> <manifest-file> <command...>
  local label="$1"; shift
  local manifest="$1"; shift
  if [ -f "$manifest" ]; then
    ran=$((ran + 1))
    echo ""
    echo "==> $label ($manifest)"
    if "$@"; then
      echo "    $label: clean"
    else
      echo "    $label: vulnerabilities reported" >&2
      failed=$((failed + 1))
    fi
  fi
}

command -v npm       >/dev/null 2>&1 && run "npm audit"      "package.json"     npm audit --audit-level=high
command -v composer  >/dev/null 2>&1 && run "composer audit" "composer.json"    composer audit
command -v pip-audit >/dev/null 2>&1 && run "pip-audit"      "requirements.txt" pip-audit -r requirements.txt
command -v bundle    >/dev/null 2>&1 && run "bundler-audit"  "Gemfile.lock"     bundle exec bundle-audit check --update

echo ""
if [ "$ran" -eq 0 ]; then
  echo "No supported manifest found in $ROOT (looked for package.json, composer.json, requirements.txt, Gemfile.lock)." >&2
  echo "Nothing to audit. If your stack differs, add its audit command here." >&2
  exit 0
fi

echo "Ran $ran audit(s); $failed reported issues."
[ "$failed" -eq 0 ] && exit 0 || exit 1

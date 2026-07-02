#!/usr/bin/env bash
#
# check-uptime.sh - synthetic availability check that asserts on both the
# HTTP status and a known body string, so it catches the "200 but broken"
# failures a plain ping misses.
#
# Usage:
#   ./check-uptime.sh <url> [expected-status] [expected-body-substring]
#
# Examples:
#   ./check-uptime.sh https://example.com
#   ./check-uptime.sh https://example.com/products 200 "Add to basket"
#
# Exit codes: 0 healthy, 1 status mismatch, 2 body assertion failed,
# 3 request failed (timeout, DNS, connection).
#
# Part of the Website Care Checklist by UK Web Marketing
# (https://ukwebmarketing.com), CC BY 4.0.

set -euo pipefail

URL="${1:-}"
EXPECTED_STATUS="${2:-200}"
EXPECTED_BODY="${3:-}"
TIMEOUT="${UPTIME_TIMEOUT:-15}"

if [ -z "$URL" ]; then
  echo "usage: $0 <url> [expected-status] [expected-body-substring]" >&2
  exit 3
fi

# Fetch body and status in one request. Body to a temp file, status via -w.
tmp_body="$(mktemp)"
trap 'rm -f "$tmp_body"' EXIT

status="$(curl -sS -L --max-time "$TIMEOUT" \
  -o "$tmp_body" \
  -w '%{http_code}' \
  "$URL")" || {
  echo "FAIL  request error for $URL (timeout, DNS, or connection refused)" >&2
  exit 3
}

if [ "$status" != "$EXPECTED_STATUS" ]; then
  echo "FAIL  $URL returned $status, expected $EXPECTED_STATUS" >&2
  exit 1
fi

if [ -n "$EXPECTED_BODY" ]; then
  if ! grep -qF -- "$EXPECTED_BODY" "$tmp_body"; then
    echo "FAIL  $URL returned $status but body did not contain: $EXPECTED_BODY" >&2
    exit 2
  fi
fi

echo "OK    $URL -> $status${EXPECTED_BODY:+ (body matched)}"
exit 0

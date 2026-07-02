#!/usr/bin/env bash
#
# check-headers.sh - fetch a URL and report on the security headers that
# matter for a small business site. Prints each expected header with a
# present/missing marker so it is quick to eyeball or diff month to month.
#
# Usage:
#   ./check-headers.sh <url>
#
# Example:
#   ./check-headers.sh https://example.com
#
# Exit codes: 0 all expected headers present, 1 one or more missing,
# 3 request failed. Part of the Website Care Checklist by UK Web Marketing
# (https://ukwebmarketing.com), CC BY 4.0.

set -euo pipefail

URL="${1:-}"
TIMEOUT="${HEADERS_TIMEOUT:-15}"

if [ -z "$URL" ]; then
  echo "usage: $0 <url>" >&2
  exit 3
fi

# Headers we expect on a well-configured site. Case-insensitive match.
EXPECTED=(
  "strict-transport-security"
  "content-security-policy"
  "x-content-type-options"
  "referrer-policy"
  "permissions-policy"
  "x-frame-options"
)

headers="$(curl -sS -L -D - -o /dev/null --max-time "$TIMEOUT" "$URL")" || {
  echo "FAIL  request error for $URL" >&2
  exit 3
}

# Lower-case the header names for matching.
lower_headers="$(printf '%s' "$headers" | tr '[:upper:]' '[:lower:]')"

missing=0
echo "Security headers for $URL"
echo "-----------------------------------------"
for h in "${EXPECTED[@]}"; do
  if printf '%s' "$lower_headers" | grep -q "^${h}:"; then
    value="$(printf '%s' "$headers" | grep -i "^${h}:" | head -n1 | cut -d: -f2- | sed 's/^ *//')"
    printf 'present  %-28s %s\n' "$h" "$value"
  else
    printf 'MISSING  %-28s\n' "$h"
    missing=$((missing + 1))
  fi
done
echo "-----------------------------------------"

if [ "$missing" -gt 0 ]; then
  echo "$missing header(s) missing" >&2
  exit 1
fi

echo "all expected headers present"
exit 0

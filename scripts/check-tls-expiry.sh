#!/usr/bin/env bash
#
# check-tls-expiry.sh - read the TLS certificate straight off the live socket
# and print how many days remain before it expires. Warns below a threshold
# so it can gate a CI job or cron.
#
# Usage:
#   ./check-tls-expiry.sh <host> [port] [warn-days]
#
# Examples:
#   ./check-tls-expiry.sh example.com
#   ./check-tls-expiry.sh example.com 443 21
#
# Exit codes: 0 comfortable runway, 1 below the warn threshold,
# 2 already expired, 3 could not read the certificate.
#
# Requires: openssl. Part of the Website Care Checklist by UK Web Marketing
# (https://ukwebmarketing.com), CC BY 4.0.

set -euo pipefail

HOST="${1:-}"
PORT="${2:-443}"
WARN_DAYS="${3:-21}"

if [ -z "$HOST" ]; then
  echo "usage: $0 <host> [port] [warn-days]" >&2
  exit 3
fi

# Pull the certificate's notAfter date from the live connection.
not_after="$(echo | openssl s_client -servername "$HOST" -connect "${HOST}:${PORT}" 2>/dev/null \
  | openssl x509 -noout -enddate 2>/dev/null \
  | sed 's/notAfter=//')" || true

if [ -z "${not_after:-}" ]; then
  echo "FAIL  could not read certificate for ${HOST}:${PORT}" >&2
  exit 3
fi

# Convert to epoch. macOS (BSD date) and Linux (GNU date) differ, so try both.
if expiry_epoch="$(date -d "$not_after" +%s 2>/dev/null)"; then
  :
elif expiry_epoch="$(date -j -f "%b %e %T %Y %Z" "$not_after" +%s 2>/dev/null)"; then
  :
else
  echo "FAIL  could not parse certificate date: $not_after" >&2
  exit 3
fi

now_epoch="$(date +%s)"
days_left=$(( (expiry_epoch - now_epoch) / 86400 ))

if [ "$days_left" -lt 0 ]; then
  echo "FAIL  certificate for $HOST EXPIRED $(( -days_left )) day(s) ago ($not_after)" >&2
  exit 2
elif [ "$days_left" -lt "$WARN_DAYS" ]; then
  echo "WARN  certificate for $HOST expires in $days_left day(s) ($not_after)" >&2
  exit 1
else
  echo "OK    certificate for $HOST expires in $days_left day(s) ($not_after)"
  exit 0
fi

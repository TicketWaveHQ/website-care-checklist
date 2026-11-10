#!/usr/bin/env bash
#
# smoke.sh - offline tests for the scripts in scripts/. Starts a local HTTP
# server (tests/server.py) and a local TLS server with a short-lived
# self-signed certificate, then checks every script's exit codes against
# known-good and known-bad cases. Talks to 127.0.0.1 only.
#
# Usage:
#   ./tests/smoke.sh
#
# Requires: bash, curl, openssl, python3. Exit code is the number of failed
# cases (0 means everything passed). Part of the Website Care Checklist by
# TicketWave HQ (https://ticketwavehq.com), CC BY 4.0.

set -uo pipefail
cd "$(dirname "$0")/.."

HTTP_PORT="${HTTP_PORT:-18080}"
TLS_PORT="${TLS_PORT:-18443}"
DEAD_PORT="${DEAD_PORT:-18099}"   # nothing listens here
BASE="http://127.0.0.1:${HTTP_PORT}"

tmp="$(mktemp -d)"
http_pid=""
tls_pid=""
cleanup() {
  for pid in $http_pid $tls_pid; do
    kill "$pid" 2>/dev/null
    wait "$pid" 2>/dev/null
  done
  rm -rf "$tmp"
}
trap cleanup EXIT

failures=0
expect() {
  # expect <wanted-exit-code> <description> <command...>
  local want="$1" desc="$2"
  shift 2
  "$@" >"$tmp/out" 2>&1
  local got=$?
  if [ "$got" -eq "$want" ]; then
    printf 'ok    %-60s exit %s\n' "$desc" "$got"
  else
    printf 'FAIL  %-60s exit %s, wanted %s\n' "$desc" "$got" "$want"
    sed 's/^/      | /' "$tmp/out"
    failures=$((failures + 1))
  fi
}

# --- fixtures --------------------------------------------------------------

python3 tests/server.py "$HTTP_PORT" &
http_pid=$!

openssl req -x509 -newkey rsa:2048 -nodes -days 10 -subj "/CN=localhost" \
  -keyout "$tmp/key.pem" -out "$tmp/cert.pem" >/dev/null 2>&1
openssl s_server -quiet -accept "$TLS_PORT" -cert "$tmp/cert.pem" \
  -key "$tmp/key.pem" -www >/dev/null 2>&1 &
tls_pid=$!

for _ in $(seq 1 50); do
  curl -s -o /dev/null "$BASE/" && break
  sleep 0.1
done
for _ in $(seq 1 50); do
  echo | openssl s_client -connect "127.0.0.1:${TLS_PORT}" >/dev/null 2>&1 && break
  sleep 0.1
done

mkdir -p "$tmp/empty-project"
export UPTIME_TIMEOUT=5 HEADERS_TIMEOUT=5

# --- check-uptime.sh ---------------------------------------------------------

expect 0 "uptime: healthy page" ./scripts/check-uptime.sh "$BASE/"
expect 0 "uptime: healthy page, body matches" ./scripts/check-uptime.sh "$BASE/" 200 "Fresh bread daily"
expect 2 "uptime: 200 but body string missing" ./scripts/check-uptime.sh "$BASE/" 200 "Out of stock"
expect 1 "uptime: 404 where 200 expected" ./scripts/check-uptime.sh "$BASE/missing"
expect 3 "uptime: nothing listening" ./scripts/check-uptime.sh "http://127.0.0.1:${DEAD_PORT}/"
expect 3 "uptime: no URL given" ./scripts/check-uptime.sh

# --- check-headers.sh --------------------------------------------------------

expect 0 "headers: all six present" ./scripts/check-headers.sh "$BASE/"
expect 1 "headers: none present" ./scripts/check-headers.sh "$BASE/bare"
expect 1 "headers: only on the redirect, not the final page" ./scripts/check-headers.sh "$BASE/redirect"
expect 3 "headers: nothing listening" ./scripts/check-headers.sh "http://127.0.0.1:${DEAD_PORT}/"

# --- check-tls-expiry.sh -----------------------------------------------------

expect 1 "tls: 10-day certificate, warn under 21 days" ./scripts/check-tls-expiry.sh 127.0.0.1 "$TLS_PORT" 21
expect 0 "tls: 10-day certificate, warn under 5 days" ./scripts/check-tls-expiry.sh 127.0.0.1 "$TLS_PORT" 5
expect 3 "tls: nothing listening" ./scripts/check-tls-expiry.sh 127.0.0.1 "$DEAD_PORT" 21

# --- dependency-audit.sh -----------------------------------------------------

expect 0 "audit: no manifest found is not a failure" ./scripts/dependency-audit.sh "$tmp/empty-project"
expect 3 "audit: directory does not exist" ./scripts/dependency-audit.sh "$tmp/no-such-dir"

echo
if [ "$failures" -eq 0 ]; then
  echo "All smoke tests passed."
else
  echo "$failures smoke test(s) failed."
fi
exit "$failures"

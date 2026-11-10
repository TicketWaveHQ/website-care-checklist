# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

Nothing yet.

## [1.0.0] - 2026-11-10

First tagged release. The checklist has been public since 2026-07-02.

### Contents

- The ten-section monthly checklist in `README.md`, the same checklist as
  data in `checklist.yml`, and a cadence table.
- `scripts/check-uptime.sh`, `scripts/check-tls-expiry.sh`,
  `scripts/check-headers.sh` and `scripts/dependency-audit.sh`.
- `.pa11yci.json` and `lighthouserc.json`.
- `templates/monthly-report.md` and a filled-in example report.
- `.github/workflows/monthly-care.yml`, the monthly run of the automatable
  checks.

### Added in this release

- `.github/workflows/ci.yml`: offline checks on every push and pull request.
  Shell syntax, JSON configs, `checklist.yml` shape, a no-em-dash check, and
  `tests/smoke.sh`, which runs every script against a local fixture server
  and a local TLS server with a 10-day self-signed certificate and checks
  15 expected exit codes. It never touches a live site.
- `tests/validate_checklist.py`: every `checklist.yml` item has its six
  fields, a documented cadence and a unique id.
- README: what the repo is, who it is for, a 60-second start, and a table of
  the repository variables that switch the monthly workflow on.
- `SECURITY.md`, pointing to TicketWave HQ's disclosure policy.
- This changelog.

### Changed

- `monthly-care.yml` checks the site you configure and nothing else. It
  reads `SITE_URL` (repository variable, or the `site_url` input when run by
  hand), plus optional `CARE_PATHS`, `TLS_HOST` and `UPTIME_BODY`. With no
  `SITE_URL` it reports that nothing is configured and succeeds, instead of
  failing against `example.com`. Uptime, header and certificate results are
  written to the run summary.
- Pa11y and Lighthouse now test the configured site: the workflow writes
  `SITE_URL` and `CARE_PATHS` into copies of the configs at run time. Before,
  both always tested the `example.com` URLs in the committed configs, even
  when `SITE_URL` was set.
- `actions/checkout@v7`, `actions/setup-node@v7`, Node 24, `pa11y-ci@4` and
  `@lhci/cli@0.15.x` (was `0.13.x`); every job has a timeout.
- The author's GitHub handle is `@eu-jordangilbert` (`@sansware` is an
  organisation account). "The free checklist" is now "the open checklist".

### Fixed

- `check-headers.sh` counted headers from every response in a redirect
  chain, so a page whose final response had no security headers passed if a
  redirect on the way sent them. Only the final response counts now.
- `check-headers.sh` piped into `grep -q` under `pipefail`, which can report
  a present header as missing; it uses here-strings instead, and strips
  carriage returns from header values.
- `dependency-audit.sh` given a directory that does not exist reported
  "nothing to audit" and exited 0. It now exits 3.
- The monthly run failed whenever it started (August and September 2026;
  the October and November runs never started, because of the
  organisation's billing lock). The September log shows why: against the
  `example.com` default, `check-headers.sh` found six headers missing, and
  Lighthouse got a 404 for `https://example.com/contact` from the committed
  config.

[Unreleased]: https://github.com/TicketWaveHQ/website-care-checklist/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/TicketWaveHQ/website-care-checklist/releases/tag/v1.0.0

# Security Policy

The scripts in [`scripts/`](scripts/) run on maintainers' machines and in CI
against live sites, so a bug in them matters. Please report privately, rather
than in a public issue, if you find for example:

- a way for a crafted URL, header or certificate to make a script run
  commands or write files it should not;
- a check that reports a site as healthy or secure when it is not (a false
  "present" for a missing security header, a false "OK" for an expiring
  certificate);
- guidance in the checklist that would leave a site materially less secure
  than it claims.

**Contact:** email [hello@ticketwavehq.com](mailto:hello@ticketwavehq.com)
and say in the subject that it is a security report. TicketWave HQ's
disclosure policy, which covers this repository, is at
<https://ticketwavehq.com/security>.

We will acknowledge your report and say what we intend to do. We do not
publish a response time. Please give us a reasonable window to fix the
issue before you publish it.

Out of scope: vulnerabilities in the tools the checklist names (Pa11y,
Lighthouse, `npm audit` and the rest) or in sites you run the scripts
against. Report those to their owners.

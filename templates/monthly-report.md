# Monthly Website Care Report

**Site:** <site name and URL>
**Period:** <month and year>
**Prepared by:** <your name>
**Date completed:** <date>
**Next cycle due:** <date>

> Copy this file to `reports/YYYY-MM-<site>.md` at the start of the cycle and
> fill it in as you work through the checklist. Any unchecked box is either a
> fix in progress or a conscious deferral with a reason. Nothing is left red
> without an owner and a date.

---

## Summary

<Two or three plain sentences: overall health this month, anything the client
should notice, anything that needs a decision. Write this last, from what you
found.>

---

## Metrics this month

| Metric | This month | Last month | Notes |
| --- | --- | --- | --- |
| Uptime | | | |
| Incidents (count / total downtime) | | | |
| Days to certificate expiry | | | |
| Days to domain expiry | | | |
| Last successful backup | | | |
| Last restore drill | | | |
| Lighthouse performance | | | |
| Lighthouse accessibility | | | |
| Largest Contentful Paint (mobile) | | | |
| Cumulative Layout Shift | | | |
| Total page weight (home) | | | |
| Open dependency advisories | | | |

---

## 1. Uptime and availability

- [ ] External uptime monitor active (5-min or better)
- [ ] Alerts reach a human on a watched route
- [ ] Homepage and one deep page checked
- [ ] Month's incidents reviewed and totalled
- [ ] Health check returns expected status and body
- [ ] DNS resolves correctly from multiple resolvers

Findings:

## 2. Backups and restore

- [ ] Backups ran on schedule (files + database)
- [ ] Backups stored off-origin and in a second location
- [ ] Real restore performed into staging this month
- [ ] Restore time measured and recorded
- [ ] Retention matches agreement; old backups pruned
- [ ] Backups encrypted with restricted access

Findings:

## 3. SSL, TLS and domain expiry

- [ ] Certificate has comfortable runway; last renewal succeeded
- [ ] Domain expiry 60+ days out or auto-renew verified
- [ ] No mixed content
- [ ] HTTP redirects to HTTPS; HSTS where appropriate
- [ ] Modern TLS config; no weak protocols or ciphers
- [ ] Certificate covers every hostname in use

Findings:

## 4. Dependency and patch sweep

- [ ] Dependency audit run
- [ ] Advisories triaged by reachability; deferrals recorded
- [ ] Patch and minor updates applied after staging tests
- [ ] CMS core, themes, plugins current; unused removed
- [ ] Abandoned dependencies flagged with a plan
- [ ] Lockfiles committed

Findings:

## 5. Security patching and hardening

- [ ] Platform and OS patches applied
- [ ] Security headers present and correct
- [ ] Admin surfaces protected (strong creds, MFA)
- [ ] Unused accounts removed; access reviewed
- [ ] Rate limiting / WAF on login and forms
- [ ] No secrets in repo or client-side code
- [ ] Least-privilege permissions; directory listing off
- [ ] Production errors are generic

Findings:

## 6. Accessibility sweep

- [ ] Automated scan across home, content page, form
- [ ] Colour contrast meets WCAG AA
- [ ] Meaningful alt text; decorative images empty alt
- [ ] Keyboard-only pass on primary journey
- [ ] Forms labelled; errors announced not colour-only
- [ ] Headings in logical order
- [ ] Captions or transcripts for media

Findings:

## 7. Performance and Core Web Vitals

- [ ] Lighthouse run on home and a conversion page
- [ ] Core Web Vitals within good range on mobile
- [ ] Images right-sized, modern format, lazy-loaded, dimensioned
- [ ] Caching and compression enabled
- [ ] Third-party scripts justified and pruned
- [ ] Page weight has not crept up

Findings:

## 8. SEO and indexing health

- [ ] Live pages indexable; no accidental noindex or robots block
- [ ] Sitemap current and canonical
- [ ] No new broken links or redirect chains
- [ ] Titles, descriptions, canonicals sane
- [ ] Structured data validates (if used)
- [ ] No new Search Console warnings

Findings:

## 9. Forms, email and integrations

- [ ] Live test through every important form
- [ ] Transactional email delivered; SPF/DKIM/DMARC pass
- [ ] Spam protection works without blocking real people
- [ ] Third-party integrations authenticate and sync
- [ ] Webhooks arriving with signatures verified

Findings:

## 10. Reporting and sign-off

- [ ] Report completed
- [ ] Every failed check has an owner and a date
- [ ] Trending metrics recorded
- [ ] Decisions and budget items flagged
- [ ] Report stored; next cycle date noted

---

## Outstanding items

| Item | Severity | Owner | Target date |
| --- | --- | --- | --- |
| | | | |

## Decisions or budget needed

<Anything that needs the client to choose or spend. Be specific about the
option, the cost or effort, and the risk of doing nothing.>

---

*Prepared using the Website Care Checklist by UK Web Marketing
(https://ukwebmarketing.com), CC BY 4.0.*

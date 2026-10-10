# Monthly Website Care Report

**Site:** Example Bakery (https://example.com)
**Period:** June 2026
**Prepared by:** Maintainer
**Date completed:** 30 June 2026
**Next cycle due:** 31 July 2026

> This is an illustrative, filled-in report showing the level of detail the
> template is meant to capture. The site and figures are invented for the
> example; nothing here is a real measurement or a guarantee.

---

## Summary

The site was healthy this month with one short outage caused by the host's
scheduled maintenance, which resolved on its own. The main action is the
contact form's confirmation email, which was landing in spam for some
recipients until we corrected the DMARC alignment mid-month. One plugin has
a security update held for staging testing and will ship early next cycle.

---

## Metrics this month

| Metric | This month | Last month | Notes |
| --- | --- | --- | --- |
| Uptime | Strong, one brief outage | Full | Host maintenance window |
| Incidents (count / total downtime) | 1 / ~6 minutes | 0 | Self-resolved |
| Days to certificate expiry | 61 | 89 | Auto-renews at 30 days |
| Days to domain expiry | 214 | 244 | Auto-renew on, card valid |
| Last successful backup | 30 June | 31 May | Nightly, off-site |
| Last restore drill | 12 June | (rotated) | Staging, data intact |
| Lighthouse performance | Good | Good | No regression |
| Lighthouse accessibility | Good | Fair | Fixed a contrast issue |
| Largest Contentful Paint (mobile) | Within range | Within range | Hero image preloaded |
| Cumulative Layout Shift | Within range | Slightly high | Added image dimensions |
| Total page weight (home) | Steady | Steady | Held flat |
| Open dependency advisories | 1 low | 0 | Patch staged for July |

---

## 1. Uptime and availability

- [x] External uptime monitor active (5-min or better)
- [x] Alerts reach a human on a watched route
- [x] Homepage and one deep page checked
- [x] Month's incidents reviewed and totalled
- [x] Health check returns expected status and body
- [x] DNS resolves correctly from multiple resolvers

Findings: One outage of roughly six minutes on 18 June during the host's
maintenance window. Monitor paged correctly and the site recovered without
intervention. The deep-page check (a product page) confirmed the database
layer, not just the cached homepage.

## 2. Backups and restore

- [x] Backups ran on schedule (files + database)
- [x] Backups stored off-origin and in a second location
- [x] Real restore performed into staging this month
- [x] Restore time measured and recorded
- [x] Retention matches agreement; old backups pruned
- [x] Backups encrypted with restricted access

Findings: Restore drill on 12 June brought the full site up in staging with
data intact. This was Example Bakery's turn in the rotation, so every site
under care now has a live restore on record this quarter.

## 3. SSL, TLS and domain expiry

- [x] Certificate has comfortable runway; last renewal succeeded
- [x] Domain expiry 60+ days out or auto-renew verified
- [x] No mixed content
- [x] HTTP redirects to HTTPS; HSTS where appropriate
- [x] Modern TLS config; no weak protocols or ciphers
- [x] Certificate covers every hostname in use

Findings: Certificate renews automatically and the last renewal completed
cleanly. Domain auto-renew confirmed with a valid card and a monitored
billing contact.

## 4. Dependency and patch sweep

- [x] Dependency audit run
- [x] Advisories triaged by reachability; deferrals recorded
- [ ] Patch and minor updates applied after staging tests
- [x] CMS core, themes, plugins current; unused removed
- [x] Abandoned dependencies flagged with a plan
- [x] Lockfiles committed

Findings: Audit surfaced one low-severity advisory in a gallery plugin. The
vulnerable path is reachable, so it is scheduled rather than dismissed. The
update is staged and will ship in the first week of July after a staging
check. Removed one deactivated plugin that was no longer in use.

## 5. Security patching and hardening

- [x] Platform and OS patches applied
- [x] Security headers present and correct
- [x] Admin surfaces protected (strong creds, MFA)
- [x] Unused accounts removed; access reviewed
- [x] Rate limiting / WAF on login and forms
- [x] No secrets in repo or client-side code
- [x] Least-privilege permissions; directory listing off
- [x] Production errors are generic

Findings: Headers checked with the included script; all present. Removed one
dormant editor account belonging to a contractor whose engagement ended.

## 6. Accessibility sweep

- [x] Automated scan across home, content page, form
- [x] Colour contrast meets WCAG AA
- [x] Meaningful alt text; decorative images empty alt
- [x] Keyboard-only pass on primary journey
- [x] Forms labelled; errors announced not colour-only
- [x] Headings in logical order
- [x] Captions or transcripts for media

Findings: The automated scan flagged a low-contrast button introduced in last
month's seasonal banner. Darkened the text to clear WCAG AA. Keyboard pass
through the order journey was clean.

## 7. Performance and Core Web Vitals

- [x] Lighthouse run on home and a conversion page
- [x] Core Web Vitals within good range on mobile
- [x] Images right-sized, modern format, lazy-loaded, dimensioned
- [x] Caching and compression enabled
- [x] Third-party scripts justified and pruned
- [x] Page weight has not crept up

Findings: Added explicit dimensions to the hero image, which settled the
layout shift that was drifting high last month. Dropped an unused social
widget that no longer earned its load cost.

## 8. SEO and indexing health

- [x] Live pages indexable; no accidental noindex or robots block
- [x] Sitemap current and canonical
- [x] No new broken links or redirect chains
- [x] Titles, descriptions, canonicals sane
- [x] Structured data validates (if used)
- [x] No new Search Console warnings

Findings: Crawl found one internal link to a retired seasonal page; repointed
it to the current menu. Recipe structured data still validates.

## 9. Forms, email and integrations

- [x] Live test through every important form
- [x] Transactional email delivered; SPF/DKIM/DMARC pass
- [x] Spam protection works without blocking real people
- [x] Third-party integrations authenticate and sync
- [x] Webhooks arriving with signatures verified

Findings: The contact form's confirmation email was landing in spam for some
recipients. Root cause was a DMARC alignment gap after a mail change last
quarter. Corrected the alignment; test messages now deliver to the inbox.

## 10. Reporting and sign-off

- [x] Report completed
- [x] Every failed check has an owner and a date
- [x] Trending metrics recorded
- [x] Decisions and budget items flagged
- [x] Report stored; next cycle date noted

---

## Outstanding items

| Item | Severity | Owner | Target date |
| --- | --- | --- | --- |
| Ship staged gallery-plugin security update | Low | Maintainer | 7 July 2026 |
| Watch DMARC pass rate for a full cycle | Low | Maintainer | 31 July 2026 |

## Decisions or budget needed

None this month. The gallery plugin has had no release in a year; if there is
still no maintainer activity by the next cycle we will price a like-for-like
replacement and bring the option to you rather than let it drift.

---

*Prepared using the Website Care Checklist by TicketWave HQ
(https://ticketwavehq.com), CC BY 4.0.*

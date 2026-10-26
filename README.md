# Website Care Checklist

**The monthly managed-website care checklist for small business sites: uptime, backups, SSL and domain expiry, dependency and accessibility sweeps, security patching, and reporting.**

A site is not "done" when it launches. It quietly rots: certificates expire, dependencies pick up CVEs, backups silently stop running, a plugin update breaks a form, an image balloons the page weight, contrast drifts below the accessibility line. Most of that decay is invisible until a customer hits it, and by then it is an emergency instead of a five-minute fix.

This repository is the checklist we actually work through every month to stop that from happening. It is written for whoever holds the pager: a freelancer looking after a handful of client sites, an in-house maintainer, or an agency running managed care at scale. Every item is a real, do-able task with a plain reason, a way to check it, and a note on how to automate it so a human never has to remember.

It is licensed **CC BY 4.0**, so you are free to fork it, rename it, and make it your own runbook. If it saves you an outage, that is the whole point.

---

## Contents

- [How to use this checklist](#how-to-use-this-checklist)
- [The monthly checklist](#the-monthly-checklist)
  - [1. Uptime and availability](#1-uptime-and-availability)
  - [2. Backups and restore](#2-backups-and-restore)
  - [3. SSL, TLS and domain expiry](#3-ssl-tls-and-domain-expiry)
  - [4. Dependency and patch sweep](#4-dependency-and-patch-sweep)
  - [5. Security patching and hardening](#5-security-patching-and-hardening)
  - [6. Accessibility sweep](#6-accessibility-sweep)
  - [7. Performance and Core Web Vitals](#7-performance-and-core-web-vitals)
  - [8. SEO and indexing health](#8-seo-and-indexing-health)
  - [9. Forms, email and integrations](#9-forms-email-and-integrations)
  - [10. Reporting and sign-off](#10-reporting-and-sign-off)
- [Cadence at a glance](#cadence-at-a-glance)
- [What is in this repo](#what-is-in-this-repo)
- [Automating the checklist](#automating-the-checklist)
- [Who maintains this](#who-maintains-this)
- [Contributing](#contributing)
- [License](#license)

---

## How to use this checklist

1. Copy [`templates/monthly-report.md`](templates/monthly-report.md) to `reports/YYYY-MM-<site>.md` at the start of each care cycle.
2. Work top to bottom through [the monthly checklist](#the-monthly-checklist). Tick each box; where a check has a tool, run the tool and paste the result.
3. Anything that fails becomes a line item with an owner and a date. A failed check is never left as a red tick.
4. File the finished report with the client or in your own records. That paper trail is what turns "trust me, we look after it" into something you can actually show.

The checklist is deliberately vendor-neutral. It works for a static site, a WordPress build, a headless front end, or a small app. Where a step names a tool, treat it as an example, not a requirement. Swap in the equivalent you already run.

A note on scope: this is a **care and maintenance** checklist, not a one-off launch checklist and not a full penetration test. It is the recurring hygiene that keeps a live site healthy between larger pieces of work.

---

## The monthly checklist

### 1. Uptime and availability

The site being up is the floor everything else stands on. You want to know it is down before the client does, and you want a record of how often it happens.

- [ ] **External uptime monitor is active** and checks the site at least every 5 minutes from outside your own network. Confirm it actually paged during any known outage this month, so you know the alerting path works.
- [ ] **Alerts reach a human** by a route that person actually watches (email plus one of SMS, push, or a chat channel). A monitor nobody sees is decoration.
- [ ] **Check the homepage and one deep page**, not just the root. A cached homepage can stay green while a database-backed page 500s.
- [ ] **Review the month's incidents**: how many, how long, what caused each. Record the totals honestly in the report rather than rounding away the bad days.
- [ ] **Confirm the status endpoint or health check** still returns what it should (correct status code, expected content string), so the monitor is testing the real app and not a friendly error page.
- [ ] **DNS resolves correctly** from more than one resolver, and there is no lingering record pointing at a decommissioned host.

*Check it:* a synthetic request that asserts on both HTTP status and a known body string catches the "200 but broken" class of failure that a plain ping misses. The included [`scripts/check-uptime.sh`](scripts/check-uptime.sh) does exactly that.

### 2. Backups and restore

An untested backup is a rumour. The only thing that counts is a restore you have actually performed.

- [ ] **Backups ran on schedule** for the whole period, covering both files and database. Look at the log, not the settings screen.
- [ ] **Backups are stored off the origin server** and in a second location or region, so losing the host does not lose the backups with it.
- [ ] **A real restore was performed this month** into a staging or throwaway environment. Confirm the site comes up and data is intact. Rotate which site you test so every site under care gets a live restore across the year.
- [ ] **Restore time is known and recorded.** "We can restore" is not an answer to a client asking "how long will I be down?".
- [ ] **Retention matches the agreement**: enough history to recover from a problem noticed late, and old backups pruned so you are not paying to store, or leaking, data you should have deleted.
- [ ] **Backups are encrypted at rest** and access to them is limited to the people who genuinely need it.

*Why it matters:* most "we have backups" stories fall apart at restore time, on a permission, a missing database dump, or a backup that has silently been failing for months. Prove the restore, then you can promise it.

### 3. SSL, TLS and domain expiry

The two cheapest, most embarrassing outages are an expired certificate and an expired domain. Both are fully preventable and both take down the whole site at once.

- [ ] **TLS certificate has comfortable runway** (renews or is renewed with well over two weeks to spare). Auto-renewal being configured is not the same as auto-renewal having succeeded, so confirm the last renewal actually completed.
- [ ] **Domain registration expiry is 60+ days out**, or auto-renew is on with a valid card and a monitored billing contact. A lapsed domain can be expensive or impossible to recover.
- [ ] **No mixed content**: every asset on an HTTPS page loads over HTTPS. One `http://` image is enough to trip a browser warning.
- [ ] **HTTP redirects to HTTPS** with a permanent redirect, and HSTS is set where appropriate.
- [ ] **TLS configuration is modern**: no deprecated protocol versions or weak ciphers still enabled.
- [ ] **The certificate covers every hostname in use**, including `www` and any subdomains, and matches what the site is actually served on.

*Check it:* [`scripts/check-tls-expiry.sh`](scripts/check-tls-expiry.sh) reads the certificate straight off the live socket and prints the days remaining, so this becomes a one-command check you can wire into a cron or CI job.

### 4. Dependency and patch sweep

Software you shipped last quarter is not the software running today's threats were written against. The gap between "released a fix" and "you applied it" is the window attackers live in.

- [ ] **Run a dependency audit** for the stack in use (`npm audit`, `composer audit`, `pip-audit`, `bundle audit`, or the platform equivalent). The [`scripts/dependency-audit.sh`](scripts/dependency-audit.sh) wrapper runs whichever manifest it finds.
- [ ] **Review each advisory on its merits.** Triage by whether the vulnerable path is actually reached, not by the raw count. Record what you deferred and why, so the decision is deliberate and revisited next month.
- [ ] **Apply patch and minor updates** after testing on staging. Hold major-version bumps for planned work, but do not let them drift so far that the eventual upgrade is a rewrite.
- [ ] **CMS core, themes, and plugins are current** (WordPress, Drupal, or similar). Remove anything deactivated and unused. Inactive code is still attackable code.
- [ ] **Abandoned dependencies are flagged.** A package with no release in years and no maintainer is a slow-motion risk; note a replacement plan.
- [ ] **Lockfiles are committed** so what you tested is what deploys.

*Why it matters:* the overwhelming majority of real-world site compromises exploit a known vulnerability in an out-of-date component that a patch already existed for. Staying current is the single highest-leverage habit on this whole list.

### 5. Security patching and hardening

Beyond dependencies, the surrounding configuration is what turns a small bug into a big incident, or contains it.

- [ ] **Server and platform patches applied**: OS packages, runtime versions, and managed-platform notices actioned.
- [ ] **Security headers present and correct**: Content-Security-Policy, X-Content-Type-Options, Referrer-Policy, and a sensible Permissions-Policy. [`scripts/check-headers.sh`](scripts/check-headers.sh) fetches and prints them for a quick eyeball.
- [ ] **Admin surfaces are protected**: strong unique credentials, multi-factor authentication where the platform allows it, and admin paths not left on guessable defaults.
- [ ] **Unused accounts removed** and access reviewed. Every login that still works is a door; close the ones nobody walks through any more.
- [ ] **Rate limiting or a WAF sits in front of login and form endpoints** to blunt brute-force and spam traffic.
- [ ] **Secrets are not in the repo or in client-side code.** A quick grep for keys and tokens in the codebase and in committed history.
- [ ] **File and directory permissions are least-privilege**, and directory listing is off.
- [ ] **Error output is generic in production**: no stack traces, framework versions, or database messages leaking to visitors.

*A boundary worth stating:* this checklist hardens a site as part of routine care. For regulated or high-assurance environments, that hardening should be built to a documented standard and evidenced, which is a deliberate, separate discipline (see [who maintains this](#who-maintains-this)).

### 6. Accessibility sweep

Accessibility is a legal expectation in many places, a moral one everywhere, and it correlates with cleaner markup and better SEO. It also drifts every time someone edits content, so it belongs in a recurring check.

- [ ] **Run an automated scan** (axe-core, Pa11y, or Lighthouse's accessibility category) across the key templates: home, a content page, and any form. Automated tools catch perhaps a third of issues, so treat a clean scan as necessary, not sufficient.
- [ ] **Colour contrast meets WCAG AA** for body text and interactive elements. Re-check after any brand or theme change.
- [ ] **Images have meaningful alt text**, and decorative images have empty alt so screen readers skip them.
- [ ] **Keyboard-only pass** on the primary journey: tab through the page, confirm every control is reachable, focus is visible, and nothing traps the keyboard.
- [ ] **Forms have associated labels**, and errors are announced, not signalled by colour alone.
- [ ] **Headings are in order** and describe the structure, so assistive tech can navigate by them.
- [ ] **Media has captions or transcripts** where there is audio or video.

*Check it:* the included [`.pa11yci.json`](.pa11yci.json) and Lighthouse config let you run the accessibility category from the command line and fail a build when it regresses, so a bad edit is caught before it ships.

### 7. Performance and Core Web Vitals

A slow site loses customers and search ranking. Performance also degrades quietly as pages accumulate scripts, uncompressed images, and third-party tags, so it is a monthly check, not a launch-day one.

- [ ] **Run Lighthouse** (or the equivalent) on a real, throttled connection against the home and a key conversion page. The [`lighthouserc.json`](lighthouserc.json) in this repo sets sensible budgets you can enforce in CI.
- [ ] **Core Web Vitals are in range**: Largest Contentful Paint, Interaction to Next Paint, and Cumulative Layout Shift within Google's "good" thresholds on mobile, which is the profile that actually bites.
- [ ] **Images are right-sized and modern format** (WebP or AVIF where supported), lazy-loaded below the fold, and served with explicit dimensions to stop layout shift.
- [ ] **Caching and compression are on**: long-lived cache headers on static assets, and text served compressed.
- [ ] **Third-party scripts are justified.** Every analytics, chat, and ad tag is a tax on load time and a privacy consideration; drop the ones nobody uses.
- [ ] **Total page weight has not crept up** month on month. Track the number so the trend is visible.

### 8. SEO and indexing health

Search health erodes from small, boring problems: a stray `noindex`, a broken redirect chain, an orphaned sitemap. Cheap to catch monthly, painful to notice a quarter late.

- [ ] **The site is indexable**: no accidental `noindex` on live pages, `robots.txt` is not blocking what should be crawled, and the important pages are actually in the index.
- [ ] **XML sitemap is current** and submitted, and it lists live, canonical URLs only.
- [ ] **No new broken links or redirect chains.** Run a crawl and fix 404s and long redirect hops.
- [ ] **Canonical tags and metadata are sane**: unique titles and descriptions on key pages, canonicals pointing where they should.
- [ ] **Structured data still validates** if the site relies on it for rich results.
- [ ] **Search Console has no new coverage or manual-action warnings** this month.

### 9. Forms, email and integrations

The parts that touch other systems break silently, because nothing on the page looks wrong. A contact form that stopped delivering can cost real business before anyone notices.

- [ ] **Submit a live test through every important form** and confirm the message actually arrives at its destination.
- [ ] **Transactional email is being delivered**, not landing in spam. Check SPF, DKIM, and DMARC are aligned and passing.
- [ ] **Spam protection is working** without blocking real people: the CAPTCHA or challenge still validates, and the honeypot still catches bots.
- [ ] **Third-party integrations are healthy**: payment, booking, CRM, or newsletter connections still authenticate and sync. Rotate or renew any API keys nearing expiry.
- [ ] **Webhooks are verified and arriving**, and signature checks are still enforced.

### 10. Reporting and sign-off

The report is the product of the care work. It is what the client sees, what protects you if something is later questioned, and what makes next month faster.

- [ ] **Fill in the monthly report** from [`templates/monthly-report.md`](templates/monthly-report.md): what was checked, what was found, what was fixed, what is outstanding.
- [ ] **Every failed check has an owner and a date.** No item is left red without a plan.
- [ ] **Record the metrics that trend**: uptime for the month, page weight, Core Web Vitals, days to next certificate and domain expiry. Trends tell the story a single snapshot cannot.
- [ ] **Flag anything needing a decision or budget** clearly, so it is a conversation and not a surprise.
- [ ] **Store the report** where the client and future-you can find it, and note the date of the next cycle.

---

## Cadence at a glance

Not every item needs the same rhythm. Monthly is the backbone; a few things are better done more or less often.

| Task group | Continuous | Weekly | Monthly | Quarterly |
| --- | --- | --- | --- | --- |
| Uptime monitoring | Automated | Review alerts | Review incident totals | |
| Backups | Automated | Verify ran | | Full restore drill (rotating) |
| SSL / domain expiry | Automated watch | | Confirm runway | |
| Dependency audit | | | Full sweep | Major-version planning |
| Security patching | Critical CVEs now | | Full sweep | Access review |
| Accessibility | | | Automated scan | Manual keyboard pass |
| Performance / CWV | | | Lighthouse run | Trend review |
| SEO / indexing | | | Crawl and Search Console | |
| Forms / email / integrations | | | Live tests | |
| Reporting | | | Client report | |

Treat "monthly" as the default and pull anything urgent forward. A critical vulnerability does not wait for the calendar.

---

## What is in this repo

```
website-care-checklist/
├── README.md                     # this file: the full checklist
├── LICENSE                       # CC BY 4.0
├── lighthouserc.json             # Lighthouse CI budgets (performance + a11y + SEO)
├── .pa11yci.json                 # Pa11y CI accessibility config
├── checklist.yml                 # the checklist as machine-readable data
├── templates/
│   └── monthly-report.md         # copy this per site, per month
├── examples/
│   └── 2026-06-example-site.md   # a filled-in report, for reference
├── scripts/
│   ├── check-uptime.sh           # status + body-string synthetic check
│   ├── check-tls-expiry.sh       # days remaining on the live certificate
│   ├── check-headers.sh          # print security headers
│   └── dependency-audit.sh       # run the right audit for the stack found
└── .github/workflows/
    └── monthly-care.yml          # scheduled run of the automatable checks
```

Every file is functional. The scripts run, the configs are valid, and the workflow is a real starting point rather than a placeholder.

---

## Automating the checklist

A checklist a human has to remember is a checklist that gets skipped in a busy month. The judgement calls stay human; the mechanical checks should run themselves and only shout when something is wrong.

- **Uptime, TLS, and domain expiry** belong on a monitor that pages you. The included scripts turn each into one command you can schedule.
- **Dependency audits, Lighthouse budgets, and accessibility scans** slot into CI so a bad change fails the build before it reaches production. See [`lighthouserc.json`](lighthouserc.json) and [`.pa11yci.json`](.pa11yci.json).
- **The scheduled workflow** in [`.github/workflows/monthly-care.yml`](.github/workflows/monthly-care.yml) runs the automatable checks on the first of each month and opens the results where you will see them, leaving the human-judgement items for the report.

The goal is that by report time, the boring checks are already done and green, and your attention is free for the things only a person can weigh.

---

## Who maintains this

This checklist is written and maintained by [Jordan Gilbert](https://veryseoly.com/jordan) ([@sansware](https://github.com/sansware)) for [TicketWave HQ](https://ticketwavehq.com), and run every month on the sites [VerySEOly](https://veryseoly.com) (formerly UK Web Marketing) builds and looks after for UK businesses.

For sites that answer to a regulator or a formal assurance standard, that same hygiene has to be built to a documented baseline and evidenced, not just performed. That is the job of our sibling brand [Custodiance](https://custodiance.com), which delivers managed infrastructure and website care built to your regulator's standard, with the paper trail to prove it. The free checklist here is the shared foundation both stand on: [VerySEOly](https://veryseoly.com) for straightforward website care, and [Custodiance](https://custodiance.com) where the assurance bar is higher.

You do not need either of them to use this repo. It is here to be useful on its own.

---

## Contributing

Improvements are welcome. If a check is missing, unclear, or plain wrong, open an issue or a pull request. Keep entries in the same shape as the rest: a concrete task, a plain reason, and where possible a way to check it and a way to automate it. Real, do-able items only. A checklist earns its keep by being run, not by being long.

---

## License

This work is licensed under a [Creative Commons Attribution 4.0 International License (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/).

You may share and adapt it, including commercially, as long as you give appropriate credit. Fork it, rebrand it, and make it your own team's runbook. Attribution to [TicketWave HQ](https://ticketwavehq.com) is all we ask. See [NOTICE](NOTICE).

# Contributing

Thanks for helping improve the Website Care Checklist. It earns its keep by
being run, so the bar for every change is simple: does it make the checklist
more useful to someone actually looking after a live site?

## What good additions look like

Keep every checklist item in the same shape as the rest:

- **A concrete task.** Something a maintainer can do and tick off, not a vague
  aspiration.
- **A plain reason.** One sentence on why it matters, in language a client
  could read.
- **A way to check it.** A command, a tool, or a specific manual action.
- **A way to automate it, where one exists.** So a human never has to
  remember the mechanical parts.

If you add an item to `README.md`, add the matching entry to `checklist.yml`
so the machine-readable form stays in step, and reflect it in
`templates/monthly-report.md` if it belongs in the report.

## House style

- British English.
- No em-dashes. Use commas or spaced hyphens.
- Plain, direct sentences. Avoid jargon where a normal word will do.
- No invented metrics, prices, uptime figures, or scores anywhere in the repo.
  The example report uses qualitative words ("strong", "within range") on
  purpose.

## Scripts

The shell scripts target Bash and aim to run on both Linux and macOS with only
`curl` and `openssl` available. Keep them dependency-light, `set -euo pipefail`
where practical, and give them clear exit codes so they can gate CI.

## How to propose a change

Open an issue to discuss anything substantial, or send a pull request for
small fixes and clear improvements. Describe what the change helps a
maintainer do.

By contributing you agree your contribution is licensed under CC BY 4.0, the
same as the rest of the project.

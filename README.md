# Skill Arsenal — Reference

A single-page, filterable catalog of the Claude Code skills installed for this account
(117 personally-installed + built-ins), grouped by category with what each does and what
it's best for.

Static site — just `index.html`, no build step. Deploys to Vercel as a static project.

## Deploy
1. In the Vercel dashboard: **Add New → Project → Import** this repo.
2. Framework preset: **Other** (no build command, output dir = root).
3. Deploy. Vercel serves `index.html` at the project URL.

Every push to `main` auto-redeploys. Regenerate `index.html` (re-run the catalog build)
and push to update.

> Marked `noindex` — the page is a personal reference. For access control, enable
> **Vercel Authentication** (or a password) on the project in Vercel → Settings → Deployment Protection.

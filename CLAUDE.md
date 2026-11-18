# CLAUDE.md

@~/.claude/profiles/sco-04-gaia-k8s/profile.md

## This workspace

This folder is a **task workspace** of the Gaia grid-to-Kubernetes role. It is a checkout of the
private `ai-sco-04-gaia-k8s` repository (AI metadata only), named `ws-` + the Jira key in
lowercase, optionally followed by a slug (e.g. `ws-sco04tsk-166-score-reports-second-command` →
`SCO04TSK-166`). Read that ticket with the `jira-issues` skill before planning. The work
repositories listed in `repos.list` are cloned next to this file by `bootstrap.sh` and ignored by
this repository's `.gitignore`.

Commit messages: work repositories use the ticket key (`SCO04TSK-166: ...`); changes to this AI
repository carry no Jira ID.

## Repositories (`gaiaagis`)

- **`agis-analysis-tools`**: our components for the cluster (Dockerfiles, Kustomize base and
  overlays, deploy scripts, docs). Branches `feature/<KEY>-<slug>`, merged to `master` by PR.
- **`agis-analysis-tools-ci`**: Harness pipelines that build those images.
- **`scikube`**: cluster-scoped resources (PVs) per cluster, applied by ArgoCD.
- **`agis-kubernetes`**: a colleague's repository, reference only; do not change it.

Local-only inputs that git ignores (e.g. `docker/score-reports/.env`, `svn_libs/`) are not
cloned: they are added by hand when a local image build needs them. Never print the content of
`.env` files.

## AI files in this workspace

- `CLAUDE.md` (this file): applies to every repository below it.
- `claude-md/<repo>/CLAUDE.md`: guidance for one work repository; `bootstrap.sh` links it into
  the repository and hides it through `.git/info/exclude`. Never write a `CLAUDE.md` directly
  into a work repository.
- `.claude/settings.json`: `kubectl get/logs/describe` allowed without prompting.
- `.claude/skills/`: skills specific to this role (general ones live in `ai-user-config`).

# ai-sco-04-gaia-k8s

AI workspace files for the **Gaia grid-to-Kubernetes migration** role (`sco-04-gaia-k8s`
profile): workspace instructions, the list of work repositories, per-repository guidance and
project skills. Kept apart from the work repositories so nothing here is ever committed into them.

## Create a task workspace

```bash
~/workspace/sco-02/ai-cm/ai-user-config/scripts/new-workspace.sh sco-04-gaia-k8s <KEY>[-<slug>]
# e.g. … sco-04-gaia-k8s SCO04TSK-166-score-reports-second-command
#   →  ~/workspace/sco-04/gaia-k8s/ws-sco04tsk-166-score-reports-second-command/
```

That clones this repository as the workspace folder and runs `./bootstrap.sh`, which installs the
user-level configuration, clones the work repositories of `repos.list` and wires their
`CLAUDE.md` files. `bootstrap.sh` is safe to re-run.

## Layout

| Path | Purpose |
|------|---------|
| `CLAUDE.md` | workspace instructions; imports the role profile |
| `repos.list` | work repositories: name, URL, branch |
| `claude-md/<repo>/CLAUDE.md` | guidance for one work repository, linked in by `bootstrap.sh` |
| `.claude/settings.json` | workspace permissions (read-only `kubectl`) |
| `.claude/skills/` | project-level skills |

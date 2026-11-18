#!/usr/bin/env bash
#
# Turns this checkout into a task workspace of the sco-04-gaia-k8s role:
#   - installs/updates the user-level AI configuration (ai-user-config)
#   - clones the work repositories listed in repos.list
#   - links each repository's CLAUDE.md from claude-md/<repo>/CLAUDE.md and hides
#     it from that repository via .git/info/exclude
#
# Usage: ./bootstrap.sh
# Safe to re-run: existing clones and links are left alone.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

REPOS_FILE="${SCRIPT_DIR}/repos.list"

# --- User-level AI configuration: one shared checkout, not per workspace ---
USER_CONFIG_REPO_URL="git@github.com:jframes/ai-user-config.git"
USER_CONFIG_DIR="${HOME}/workspace/sco-02/ai-cm/ai-user-config"
if [ -d "${USER_CONFIG_DIR}/.git" ]; then
  echo "→ Updating ai-user-config..."
  git -C "${USER_CONFIG_DIR}" pull --ff-only || echo "⚠ could not fast-forward ai-user-config (local changes?), continuing"
else
  echo "→ Cloning ai-user-config..."
  git clone "${USER_CONFIG_REPO_URL}" "${USER_CONFIG_DIR}"
fi
"${USER_CONFIG_DIR}/install.sh"
echo

# --- Work repositories ---
failed=0
while read -r name url branch; do
  case "${name}" in ''|'#'*) continue ;; esac
  repo_dir="${SCRIPT_DIR}/${name}"

  if [ -d "${repo_dir}/.git" ]; then
    echo "✓ ${name} already checked out, skipping clone"
  else
    echo "→ Cloning ${name}..."
    if [ "${branch}" = "-" ]; then
      git clone "${url}" "${repo_dir}" || { echo "⚠ could not clone ${name} (does it exist yet?)"; failed=1; continue; }
    else
      git clone --branch "${branch}" "${url}" "${repo_dir}" || { echo "⚠ could not clone ${name}"; failed=1; continue; }
    fi
  fi

  claude_md="${SCRIPT_DIR}/claude-md/${name}/CLAUDE.md"
  if [ -f "${claude_md}" ]; then
    link="${repo_dir}/CLAUDE.md"
    if [ ! -e "${link}" ]; then
      ln -s "../claude-md/${name}/CLAUDE.md" "${link}"
      echo "  linked CLAUDE.md"
    fi
    exclude_file="${repo_dir}/.git/info/exclude"
    if ! grep -qx "/CLAUDE.md" "${exclude_file}" 2>/dev/null; then
      echo "/CLAUDE.md" >> "${exclude_file}"
      echo "  excluded CLAUDE.md from ${name}'s git status"
    fi
  fi
done < "${REPOS_FILE}"

echo
if [ "${failed}" -eq 1 ]; then
  echo "Workspace ready, but some repositories could not be cloned — re-run ./bootstrap.sh when they exist."
else
  echo "Done. Workspace ready."
fi

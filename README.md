# engineering-lab

Experiments and tooling for cloud, containers, and infrastructure automation.

## Quick start: Ansible locally (macOS vs Windows)

| Step | macOS / Linux (native) | Windows (PowerShell + WSL) |
|------|------------------------|----------------------------|
| 1. Clone | `git clone … && cd engineering-lab` | Same |
| 2. One-time venv + deps | See [Ansible on macOS](#ansible-on-macos-and-native-linux) (`.venv/`) | See [Ansible on WSL](#ansible-on-wsl-windows) (`.venv-wsl/` inside WSL) |
| 3. Run tools | `./scripts/ansible-macos.sh ansible --version` | `.\scripts\ansible-wsl.ps1 ansible --version` |
| 4. Lint (optional) | `./scripts/ansible-macos.sh ansible-lint .` | `.\scripts\ansible-wsl.ps1 ansible-lint .` |

**Rule of thumb:** Ansible runs **inside** a Python virtualenv; this repo never commits the venv. Controllers: **native shell** on Mac/Linux, **WSL Linux** on Windows (not Windows Python for playbooks).

## Repository layout

| Path | Purpose |
|------|---------|
| [`ansible/`](ansible/) | Ansible Galaxy collections manifest (`collections.yml`) |
| [`scripts/`](scripts/) | Helpers: [`ansible-macos.sh`](scripts/ansible-macos.sh) (macOS / native Linux), [`ansible-wsl.ps1`](scripts/ansible-wsl.ps1) (Windows + WSL) |
| [`requirements-ansible.txt`](requirements-ansible.txt) | Python pins for Ansible Core and `ansible-lint` (install into a local venv — not committed) |
| [`iam/`](iam/) | IAM-related material (as present on `main`) |

**Virtualenv locations (all gitignored):**

| OS | Path | Used by |
|----|------|---------|
| macOS / Linux (native) | `.venv/` | [`scripts/ansible-macos.sh`](scripts/ansible-macos.sh) |
| Windows (WSL) | `.venv-wsl/` | [`scripts/ansible-wsl.ps1`](scripts/ansible-wsl.ps1) |

## Prerequisites

### Windows

Install via [winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/) or vendor installers.

### macOS

Install via [Homebrew](https://brew.sh/) where applicable (`brew install python`, `brew install --cask docker`, etc.), or use vendor installers. **Python 3** must be available as `python3` (Xcode Command Line Tools or Homebrew).

### Toolchain

| Tool | Role |
|------|------|
| Git | Version control |
| Node.js | JavaScript / tooling |
| Python 3 | Scripts / automation; Ansible controller |
| Java | JVM projects (optional) |
| Docker | Containers; required for kind |
| Terraform | Infrastructure as code |
| AWS CLI v2 | AWS API |
| GitHub CLI (gh) | GitHub from the terminal |
| kubectl | Kubernetes |
| Helm | Kubernetes packages |
| kind | Local Kubernetes clusters |
| [Gitleaks](https://github.com/gitleaks/gitleaks) | Local secret scanning in repo and history |

Verify versions:

```bash
git --version
node --version
python3 --version
java -version
docker --version
terraform -version
aws --version
gh version
kubectl version --client
helm version
kind --version
gitleaks version
```

On **Windows PowerShell** you can use the same commands, or `python` instead of `python3` if that is how Python is exposed on your PATH.

If `terraform version` shows `windows_386`, an older 32-bit `terraform.exe` earlier on your `PATH` is shadowing the correct build. Remove or rename it so the `windows_amd64` binary from winget is used.

## Ansible on macOS (and native Linux)

Use a **local virtualenv** at `.venv/` (gitignored). [`scripts/ansible-macos.sh`](scripts/ansible-macos.sh) activates it and runs your command from the **repository root**, so Ansible resolves paths and config consistently.

### One-time setup

From the repository root in **Terminal** (bash/zsh):

```bash
# If ./scripts/ansible-macos.sh is not executable: chmod +x scripts/ansible-macos.sh
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
pip install -r requirements-ansible.txt
ansible-galaxy collection install -r ansible/collections.yml
deactivate
```

### Day-to-day

```bash
./scripts/ansible-macos.sh ansible --version
./scripts/ansible-macos.sh ansible-lint .
./scripts/ansible-macos.sh ansible-playbook -i inventory playbook.yml
```

- With **no arguments**, the script opens an interactive shell (`$SHELL`, default `/bin/zsh` on macOS) with the venv activated.
- The same script works on **Linux** (non-WSL) if you use `.venv/` the same way.

## Ansible on WSL (Windows)

Ansible is most reliable on Windows when the **controller** runs inside **WSL** (Linux) with a dedicated virtual environment at `.venv-wsl/` (gitignored).

1. Open WSL (e.g. Ubuntu), `cd` to this repository clone (Linux path under `/mnt/...`).
2. Create and activate a venv, install Python deps, install collections:

```bash
python3 -m venv .venv-wsl
source .venv-wsl/bin/activate
python -m pip install --upgrade pip
pip install -r requirements-ansible.txt
ansible-galaxy collection install -r ansible/collections.yml
```

3. From **PowerShell** at the repo root on Windows, delegate to that venv via [`scripts/ansible-wsl.ps1`](scripts/ansible-wsl.ps1):

```powershell
.\scripts\ansible-wsl.ps1 ansible --version
.\scripts\ansible-wsl.ps1 ansible-lint .
```

Use `-Distro <Name>` if your distribution is not `Ubuntu` (list distros: `wsl -l -v`). Example: `.\scripts\ansible-wsl.ps1 -Distro Debian ansible --version`.

**Requirements:** Repository must live on a **drive letter path** (e.g. `C:\dev\...`). UNC (`\\server\share`) paths are not supported by this script. The WSL path must exist at `/mnt/<drive>/...`.

## Troubleshooting (Ansible / local dev)

| Symptom | What to check |
|--------|----------------|
| `python3: command not found` (Mac) | Install Xcode Command Line Tools (`xcode-select --install`) or `brew install python`. |
| `Missing virtualenv` when running helper | Complete the one-time venv + `pip install` + `ansible-galaxy collection install` for your OS (see tables above). |
| `ansible-galaxy collection install` fails | Upgrade pip first; check TLS/proxy; verify [Galaxy](https://galaxy.ansible.com/) is reachable. Collections listed in [`ansible/collections.yml`](ansible/collections.yml) must exist on Galaxy (e.g. `ansible.utils`, `ansible.mcp`). |
| WSL script errors on path | Use a checkout under `C:\` (or `D:\` etc.), not a UNC path. |
| Wrong WSL distro | Run `wsl -l -v`, then pass `-Distro <ExactName>` to `ansible-wsl.ps1`. |
| Line endings on Windows | Shell scripts use LF per [`.gitattributes`](.gitattributes); clone with `core.autocrlf` left to Git defaults for your platform. |

## Cursor IDE: MCP and rules (global only)

This repository does **not** ship a per-project `mcp.json`. Configure MCP once in your **user** Cursor directory so it applies to every workspace:

| OS | MCP config | Rules (`.mdc`) |
|----|------------|----------------|
| Windows | `%USERPROFILE%\.cursor\mcp.json` | `%USERPROFILE%\.cursor\rules\` |
| macOS / Linux | `~/.cursor/mcp.json` | `~/.cursor/rules/` |

Keep secrets out of git: the real MCP file stays on your machine; do not copy it into this repo or commit tokens.

**Cursor rules** use `alwaysApply: true` in frontmatter. Do not add project-level `.cursor/rules/` unless you have a deliberate exception for one repository.

## Clone and work locally

```bash
git clone https://github.com/sanjeev0120test/engineering-lab.git
cd engineering-lab
```

## Secrets and local-only configuration

- **`.gitignore`:** Commit and push it. It is the shared rulebook for what must **not** enter git (artifacts, secrets, local overrides). Only personal one-off ignores belong in your global git config or `.git/info/exclude`.
- **Parameterized values:** Put secrets and environment-specific values in `.env` (see [`.env.example`](.env.example)), `*.tfvars`, or your OS user profile (`~/.aws`, etc.). Those paths are covered by [`.gitignore`](.gitignore).
- **Git / GitHub:** Use [Git Credential Manager](https://github.com/git-ecosystem/git-credential-manager) or `gh auth login` — do not embed tokens in remote URLs or committed files.
- **Terraform:** Commit `.terraform.lock.hcl` when you add Terraform code; keep `terraform.tfstate` and `*.auto.tfvars` local (ignored).
- **Scan before push:** From the repo root, run `gitleaks detect -v` to check tracked files and git history for accidental secrets.

## License

See [LICENSE](LICENSE).

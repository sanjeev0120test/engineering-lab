# engineering-lab

Experiments and tooling for cloud, containers, and infrastructure automation.

## Repository layout

| Path | Purpose |
|------|---------|
| [`ansible/`](ansible/) | Ansible Galaxy collections manifest (`collections.yml`) |
| [`scripts/`](scripts/) | Cross-platform helpers (e.g. WSL Ansible runner) |
| [`requirements-ansible.txt`](requirements-ansible.txt) | Python pins for Ansible Core and `ansible-lint` (WSL venv) |
| [`iam/`](iam/) | IAM-related material (as present on `main`) |

## Prerequisites

Typical toolchain (install via [winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/) or vendor installers):

| Tool | Role |
|------|------|
| Git | Version control |
| Node.js | JavaScript / tooling |
| Python 3 | Scripts / automation; Ansible controller (WSL) |
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

```powershell
git --version
node --version
python --version
java -version
docker --version
terraform -version
aws --version
gh --version
kubectl version --client
helm version
kind --version
gitleaks version
```

If `terraform version` shows `windows_386`, an older 32-bit `terraform.exe` earlier on your `PATH` is shadowing the correct build. Remove or rename it so the `windows_amd64` binary from winget is used.

## Ansible on WSL (Windows)

Ansible is most reliable on Windows when the **controller** runs inside **WSL** (Linux) with a dedicated virtual environment. This repo does **not** commit the venv (`.venv-wsl/` is gitignored).

1. Open WSL (e.g. Ubuntu), `cd` to this repository clone (Linux path under `/mnt/...`).
2. Create and activate a venv, install Python deps, install collections:

```bash
python3 -m venv .venv-wsl
source .venv-wsl/bin/activate
pip install -r requirements-ansible.txt
ansible-galaxy collection install -r ansible/collections.yml
```

3. From **PowerShell** at the repo root on Windows, you can delegate to that venv via [`scripts/ansible-wsl.ps1`](scripts/ansible-wsl.ps1):

```powershell
.\scripts\ansible-wsl.ps1 ansible --version
.\scripts\ansible-wsl.ps1 ansible-lint .
```

Adjust `-d Ubuntu` in the script if your default WSL distro name differs.

## Cursor IDE: MCP and rules (global only)

This repository does **not** ship a per-project `mcp.json`. Configure MCP once in your **user** Cursor directory so it applies to every workspace:

- **Windows:** `%USERPROFILE%\.cursor\mcp.json`
- **Linux / macOS:** `~/.cursor/mcp.json`

Keep secrets out of git: the real file stays on your machine; do not copy it into this repo or commit tokens.

**Cursor rules** (team standards, security, AWS cost guardrails) live under `%USERPROFILE%\.cursor\rules\` as `.mdc` files with `alwaysApply: true`. Do not duplicate project-level `.cursor/rules/` unless you have a deliberate exception for one repository.

## Clone and work locally

```powershell
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

# engineering-lab

Experiments and tooling for cloud, containers, and infrastructure.

## Prerequisites

Typical toolchain (install via [winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/) or vendor installers):

| Tool | Role |
|------|------|
| Git | Version control |
| Node.js | JavaScript / tooling |
| Python 3 | Scripts / automation |
| Java | JVM projects (optional) |
| Docker | Containers; required for kind |
| Terraform | Infrastructure as code |
| AWS CLI v2 | AWS API |
| GitHub CLI (`gh`) | GitHub from the terminal |
| kubectl | Kubernetes |
| Helm | Kubernetes packages |
| kind | Local Kubernetes clusters |
| [Gitleaks](https://github.com/gitleaks/gitleaks) | Local secret scanning in repo and history |
| [uv](https://docs.astral.sh/uv/) | Python tool runner (AWS Documentation / AWS API MCP servers) |

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
uv --version
```

If `terraform version` shows `windows_386`, an older 32-bit `terraform.exe` earlier on your `PATH` is shadowing the correct build. Remove or rename it so the `windows_amd64` binary from winget is used.

## Clone and work locally

```powershell
git clone https://github.com/sanjeev0120test/engineering-lab.git
cd engineering-lab
```

## Cursor MCP (optional)

This repo includes a starter [`.cursor/mcp.json`](.cursor/mcp.json) with **official** servers only:

| Server | Source | Notes |
|--------|--------|--------|
| **github** | [github/github-mcp-server](https://github.com/github/github-mcp-server) (remote) | Replace `YOUR_GITHUB_PAT` with a [fine-grained or classic PAT](https://github.com/settings/personal-access-tokens). Requires Cursor with Streamable HTTP support. **Never commit a real token**—use a placeholder in git; keep secrets in user-level config if you prefer. |
| **aws-knowledge** | [awslabs/mcp](https://github.com/awslabs/mcp) — managed endpoint | Remote AWS Knowledge MCP (`https://knowledge-mcp.global.api.aws`). |
| **aws-documentation** | [awslabs/mcp](https://github.com/awslabs/mcp) | Runs locally via [`uv`](https://docs.astral.sh/uv/); install with `winget install astral-sh.uv` (or see Astral docs). |
| **aws-api** | [awslabs/mcp](https://github.com/awslabs/mcp) | **Disabled by default.** Uses your [AWS CLI credential chain](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html). Set `"disabled": false` when ready; narrow IAM permissions to what you need. |

**Global vs project:** Cursor reads **`%USERPROFILE%\.cursor\mcp.json`** for all workspaces, or **`.cursor/mcp.json`** in a project for that repo only. Copy or merge this file into either location, then restart Cursor. See GitHub’s [Cursor install guide](https://github.com/github/github-mcp-server/blob/main/docs/installation-guides/install-cursor.md) and the [awslabs/mcp](https://github.com/awslabs/mcp) README for Windows `uv` patterns and more servers.

## Secrets and local-only configuration

- **`.gitignore`:** Commit and push it. It is the shared rulebook for what must **not** enter git (artifacts, secrets, local overrides). Only personal one-off ignores belong in your global git config or `.git/info/exclude`.
- **Parameterized values:** Put secrets and environment-specific values in `.env` (see [`.env.example`](.env.example)), `*.tfvars`, or your OS user profile (`~/.aws`, etc.). Those paths are covered by [`.gitignore`](.gitignore).
- **Git / GitHub:** Use [Git Credential Manager](https://github.com/git-ecosystem/git-credential-manager) or `gh auth login` — do not embed tokens in remote URLs or committed files.
- **Terraform:** Commit `.terraform.lock.hcl` when you add Terraform code; keep `terraform.tfstate` and `*.auto.tfvars` local (ignored).
- **Scan before push:** From the repo root, run `gitleaks detect -v` to check tracked files and git history for accidental secrets.

## License

See [LICENSE](LICENSE).

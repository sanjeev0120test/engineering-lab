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

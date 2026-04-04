# engineering-lab

Experiments and tooling for cloud, containers, and infrastructure.

Upstream: [github.com/sanjeev0120test/engineering-lab](https://github.com/sanjeev0120test/engineering-lab)

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
```

## Clone and work locally

```powershell
git clone https://github.com/sanjeev0120test/engineering-lab.git
cd engineering-lab
```

## Secrets

Do not commit API keys, tokens, or cloud credentials. Use `.env` locally (see `.env.example`); `.env` is gitignored. Prefer [Git Credential Manager](https://github.com/git-ecosystem/git-credential-manager) for Git HTTPS auth.

## License

See [LICENSE](LICENSE).

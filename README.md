

Readme · MD
# Terraform Practice
 
Hands-on Terraform and Terragrunt learning on AWS. Each folder is a self-contained exercise on one concept, with its own `main.tf`. Work progresses from basics (variables, locals) to modules, state management, imports, and Terragrunt.
 
> This is a learning repo, not production code. Several exercises intentionally use simplified or insecure settings (open security groups, local state). Do not copy them into real infrastructure without review.
 
## Contents
 
- [Topics covered](#topics-covered)
- [Repository layout](#repository-layout)
- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [How to run an exercise](#how-to-run-an-exercise)
- [Capstone: VPC + EC2 with modules](#capstone-vpc--ec2-with-modules)
- [Cost and cleanup](#cost-and-cleanup)
- [Security notes](#security-notes)
- [Conventions](#conventions)
- [Roadmap](#roadmap)
## Topics covered
 
| Area | Concepts practiced | Folder |
|---|---|---|
| Fundamentals | Provider, resources, data sources, outputs | `terraform_demo_01` |
| Variables | `.tfvars` per environment, variable types, env scripts | `variables` |
| Locals | Local values, expressions | `locals` |
| Dynamic blocks | `dynamic` blocks, `for_each` over rules | `dynamic_blocks` |
| Dependencies | Implicit vs explicit `depends_on` | `depends_on` |
| Provisioners | `local-exec`, `remote-exec`, file provisioner on security group and EC2 | `sg_and_provisioners` |
| `null_resource` | Triggers, running local commands | `null_resource` |
| User data | Bootstrapping an instance (Apache install) | `user_data` |
| Validation and logging | Variable validation, debug logging | `logging_validation` |
| Templates | `templatefile()`, `.tpl` / `.tftpl`, IAM policy rendering, file data sources | `tf_templates` |
| Modules | Calling and writing local modules, passing inputs and outputs | `tf_modules` |
| Workspaces | `dev` / `test` workspaces, per-workspace state | `tf_workspace` |
| Remote state | S3 backend, S3-native locking (`use_lockfile`) | `state_file_s3` |
| Import | Bringing existing EC2 and S3 under Terraform | `import_infra` |
| Serverless | Lambda, IAM role and policy, zip packaging with `archive_file` | `lambda_using_tf` |
| Terragrunt | Registry modules via `tfr://`, `generate`, shared YAML config, `dev` / `test` units | `terragrunt_prac` |
| Capstone | VPC, subnets, IGW, NAT, route tables, SG, EC2, all as modules | `custom_tasks` |
 
## Repository layout
 
```
Terraform_prac/
├── custom_tasks/          # capstone: VPC + SG + EC2 modules
├── depends_on/
├── dynamic_blocks/
├── import_infra/
│   ├── aws_ec2_instance/
│   └── aws_s3/
├── lambda_using_tf/
├── locals/
├── logging_validation/
├── null_resource/
├── sg_and_provisioners/
├── state_file_s3/
│   ├── project-1/
│   └── project-2/
├── terraform_demo_01/
├── terragrunt_prac/
│   ├── terragrunt.hcl     # root config
│   ├── common-environment.yaml
│   ├── dev/
│   └── test/
├── tf_modules/
│   ├── module-1/
│   └── module-2/
├── tf_templates/
│   ├── aws_iam_policy/
│   ├── file_data_source/
│   ├── null_data_source/
│   ├── s3_bucket/
│   ├── templatefile_function/
│   └── templatefile_function_locals/
├── tf_workspace/
├── user_data/
└── variables/
```
 
## Prerequisites
 
- An AWS account and an **IAM user** (not root) with permissions for the services you test.
- Linux or WSL2 Ubuntu. These exercises were written and run on WSL2.
- Tools:
| Tool | Version used / needed |
|---|---|
| Terraform | 1.10+ (needed for `use_lockfile` S3 locking) |
| AWS CLI | v2 |
| Terragrunt | recent release (only for `terragrunt_prac`) |
| AWS provider | `~> 6.0` (see each folder's `.terraform.lock.hcl`) |
 
## Setup
 
```bash
# 1. Clone
git clone git@github.com:<your-username>/<repo-name>.git
cd <repo-name>
 
# 2. Configure AWS credentials (default region used in most folders: ap-south-1)
aws configure
aws sts get-caller-identity     # confirm it works
 
# 3. Verify tools
terraform -version
aws --version
terragrunt --version            # optional
```
 
Tip: clone into the Linux filesystem (`~/`), not `/mnt/c/...`, on WSL. It is much faster and avoids permission quirks.
 
## How to run an exercise
 
```bash
cd <folder>
terraform init
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
# ... experiment ...
terraform destroy
```
 
Always read the plan before applying, and always destroy when you finish.
 
Some folders need extra inputs:
 
- `variables/`: `terraform plan -var-file=dev.tfvars` (also `staging.tfvars`, `production.tfvars`).
- `tf_workspace/`: `terraform workspace new dev` (or `select dev`) before plan.
- `terragrunt_prac/`: run from `dev/` or `test/`: `terragrunt init && terragrunt plan`.
- `tf_templates/*`: `terraform apply`, then `terraform output -raw <name>` to see the rendered result.
## Capstone: VPC + EC2 with modules
 
`custom_tasks/` builds a small network from reusable modules with no hardcoded values; everything is driven by `terraform.tfvars`.
 
**Task:** create a VPC with 4 subnets (2 public, 2 private), an EC2 instance, a security group attached to it, an Internet Gateway, and a NAT Gateway.
 
```
modules/
├── vpc/   # VPC, subnets (for_each), IGW, EIP, NAT, route tables + associations
├── sg/    # security group + ingress/egress rules (for_each)
└── ec2/   # instance, AMI via SSM parameter, IMDSv2, encrypted root volume
```
 
Before applying, set your own IP in `terraform.tfvars`:
 
```hcl
cidr_ipv4 = "<your-ip>/32"   # in sg_ingress_rules.ssh
```
 
Get it with `curl -s https://checkip.amazonaws.com`.
 
## Cost and cleanup
 
Most exercises fit in the free tier or cost cents. These do not:
 
| Resource | Approximate cost |
|---|---|
| NAT Gateway (`custom_tasks`) | roughly $30+/month while running, plus data transfer |
| Elastic IP not attached to a running resource | small hourly charge |
| EC2 instances left running | hourly, varies by type |
 
**Run `terraform destroy` in every folder when you finish.** Check the AWS console for leftovers (NAT gateways, EIPs, EC2, S3 buckets, Lambda, CloudWatch log groups). Consider setting an AWS Budget alert.
 
## Security notes
 
- **State files are never committed.** `.gitignore` excludes `*.tfstate*`, `.terraform/`, `.terragrunt-cache/`, plan files and zips. State can contain secrets and account details.
- **No credentials in this repo.** Authentication comes from `~/.aws/credentials` or environment variables. Use an IAM user, never root keys.
- **Open ports in exercises** (`0.0.0.0/0` on SSH) exist only to keep the demos simple. Restrict SSH to your own IP or use SSM Session Manager.
- If you spot a secret in this repo, rotate it first, then open an issue.
## Conventions
 
- Files per module: `main.tf`, `variables.tf`, `outputs.tf`.
- Inputs go in variables with a type and description; values go in `.tfvars`, not in resources.
- `for_each` over maps for repeated resources (subnets, route table associations, SG rules).
- Folder names use `snake_case`, no spaces or special characters.
- Run `terraform fmt -recursive` before every commit.
- Pin provider and Terraform versions in a `terraform` block.
## Roadmap
 
- [x] Variables, locals, outputs
- [x] Dynamic blocks, `depends_on`, provisioners
- [x] Templates and `templatefile()`
- [x] Modules (local)
- [x] Workspaces
- [x] Remote state on S3
- [x] Import existing resources
- [x] Lambda deployment
- [x] Terragrunt basics
- [ ] `import` blocks and `-generate-config-out`
- [ ] Terragrunt: root `remote_state`, `include`, `dependency` between units
- [ ] Per-AZ NAT gateways
- [ ] SSM Session Manager instead of SSH
- [ ] Registry modules (`terraform-aws-modules/vpc/aws`)
- [ ] CI pipeline: `fmt`, `validate`, `tflint`, `checkov`, plan on pull request
- [ ] `terraform test` for module testing
## License
 
Personal learning material. Use freely at your own risk.
 
Claude finished the response

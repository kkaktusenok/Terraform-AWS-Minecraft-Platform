# Minecraft Server on AWS — Full IaC (Terraform + Packer)

[![Terraform](https://img.shields.io/badge/Terraform-1.6%2B-5B43CC?style=for-the-badge&logo=terraform&logoColor=white)](https://terraform.io)
[![Packer](https://img.shields.io/badge/Packer-1.11%2B-00ADD8?style=for-the-badge&logo=packer&logoColor=white)](https://packer.io)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com)
[![Minecraft](https://img.shields.io/badge/Minecraft-1.21.10-62B47A?style=for-the-badge&logo=minecraft&logoColor=white)]()
[![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

**Production-ready PaperMC 1.21.10 server on AWS using 100% Infrastructure as Code.**

- Immutable Golden AMI via Packer
- Elastic IP — address never changes
- Automatic world backup & restore from S3
- One-command deploy: `terraform apply`
- Zero manual actions in AWS Console

## Features

- Packer → Golden AMI (Ubuntu 20.04 + Java 21 + PaperMC + systemd + S3 sync)
- Elastic IP — permanent server address
- Automatic world backup & restore from S3 (survives `terraform destroy`)
- t3.medium (4 GB RAM) — smooth 20–50 players
- Full Terraform: VPC, IGW, public subnet, Security Groups
- Works with VS Code + AWS Toolkit (SSO) — no keys in code
- Ready for GitHub Actions and freelance jobs

## Architecture

```mermaid
graph TD
    A[Internet] -->|TCP 25565| BElastic IP]
    B --> Ct3.medium EC2]
    C --> DPaperMC 1.21.10<br/>Java 21]
    C --> E[/minecraft/world]
    C -->|cron every 15 min| FS3 Bucket]
    F -->|restore on boot| E


Quick Start (5 minutes)

git clone https://github.com/your-username/Terraform-AWS-Minecraft-Platform.git
cd Terraform-AWS-Minecraft-Platform

# Build Golden AMI (first time only)
packer build minecraft.json

# Deploy everything
terraform init
terraform apply -auto-approve

Server IP:
terraform output -raw public_ip

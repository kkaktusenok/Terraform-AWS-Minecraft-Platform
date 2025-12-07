# Terraform-AWS-Minecraft-Platform

[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=flat&logo=terraform&logoColor=white)](https://www.terraform.io)
[![Packer](https://img.shields.io/badge/packer-%2300ADD8.svg?style=flat&logo=packer&logoColor=white)](https://www.packer.io)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=flat&logo=amazon-aws&logoColor=white)](https://aws.amazon.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**Production-ready Minecraft 1.21.10 PaperMC server on AWS using 100% Infrastructure as Code.**

No manual actions in AWS Console · Elastic IP · S3 world backup · Golden AMI · One-command deploy

## Features

- Packer → **Golden AMI** (Ubuntu 20.04 + Java 21 + PaperMC + systemd + auto S3 backup)
- Terraform → VPC, public subnet, IGW, Security Groups, Elastic IP, t3.medium
- Automatic **world backup & restore** from S3 (survives `terraform destroy`)
- Permanent server address (Elastic IP)
- Works with **VS Code + AWS Toolkit** (SSO) — no keys in code
- Ready for GitHub Actions CI/CD

## Architecture

```mermaid
graph TD
    A[Internet] -->|TCP 25565| B[Elastic IP]
    B --> C[t3.medium EC2]
    C --> D[PaperMC 1.21.10<br/>Java 21]
    C --> E[/minecraft/world]
    C -->|cron every 15 min| F[S3 Bucket<br/>main-s3-bucket-devdan]
    F -->|restore on boot| E

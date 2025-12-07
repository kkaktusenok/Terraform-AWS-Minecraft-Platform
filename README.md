# 🚀 Terraform & Packer: Immutable Minecraft Server Platform

This project implements a fully automated, scalable, and secure Minecraft server platform on AWS using **Infrastructure as Code (IaC)** principles.

The goal is to demonstrate a robust CI/CD pipeline for managing an **Immutable Infrastructure** architecture. 

---

## 💡 Key Features & Technologies

This solution demonstrates expertise in the following areas:

### Infrastructure as Code & State Management
* **Terraform (IaC):** Manages the entire AWS infrastructure (VPC, Networking, EIP, Security Groups).
* **S3 Backend:** Remote state storage is configured using an encrypted S3 bucket.
* **State Locking:** Implemented using **DynamoDB** to prevent state corruption during concurrent operations.
* **Elastic IP (EIP):** Ensures the server has a **permanent, static IP address**, allowing players to connect without relying on dynamic DNS.

### Immutable Infrastructure
* **Packer:** Used to build a **"Golden AMI"** (Amazon Machine Image) that contains the pre-installed Java runtime, Minecraft server software, and systemd service configuration.
* **Zero-Downtime Updates:** Any server update (e.g., changing the Minecraft version in the Packer template) triggers the creation of a brand new EC2 instance from the new AMI before destroying the old one.

### DevOps & Automation
* **GitHub Actions (CI/CD):** Implements an end-to-end pipeline that automatically builds a new AMI and deploys the updated EC2 instance upon a code push.
* **Local Automation:** Terraform uses `local-exec` to automatically update the local `~/.ssh/config` file with the EIP and SSH key path, simplifying server access.

---

## 🛠️ Prerequisites

* An AWS Account with Access Key ID and Secret Access Key.
* **Terraform** ($\ge 1.0$) and **Packer** ($\ge 1.7$) installed locally.
* AWS CLI configured with a named profile (e.g., `danvscode`).
* **GitHub Repository Secrets:** Must be configured with `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and a `GH_DISPATCH_TOKEN` for CI/CD.

---

## 🚀 Deployment Instructions

### 1. Initialize Backend Resources

To successfully migrate the state, we first create the S3 bucket and DynamoDB table.

1.  **Temporarily comment out** the `backend "s3"` block in `backend.tf`.
2.  Run the initial setup to create the remote state bucket and lock table:
    ```bash
    terraform init
    terraform apply -auto-approve
    ```

### 2. Migrate State to S3

1.  **Uncomment** the `backend "s3"` block in `backend.tf`. Ensure the `profile` is set correctly.
2.  Run the migration command:
    ```bash
    terraform init -migrate-state
    ```

### 3. Build and Deploy (CI/CD)

The primary workflow is now handled by GitHub Actions:

1.  **To Update the Server:** Edit the Minecraft configuration in `packer/minecraft.json` (e.g., change the Java version or server JAR).
2.  **Commit and Push:**
    ```bash
    git add .
    git commit -m "feat: updated minecraft version and triggered CI/CD"
    git push
    ```
3.  **Monitor:** Check the **Actions** tab on GitHub. The CI pipeline will build a new AMI, and the CD pipeline will deploy a replacement EC2 instance.

---

## 🧹 Cleanup

To destroy all AWS resources created by Terraform:

```bash
terraform destroy

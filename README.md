# 🚀 Terraform & Packer: Immutable Minecraft Server Platform

This project implements a fully automated, scalable, and secure Minecraft server platform on AWS using **Infrastructure as Code (IaC)** principles.

The goal is to demonstrate a robust process for managing an **Immutable Infrastructure** architecture.

---

## ⚡ Quick Start Flow

1.  **Configure:** Open `packer/minecraft.json` and set your `aws_profile`.
2.  **Build AMI:** Create the Golden AMI containing the server software.
    ```bash
    cd packer && packer build minecraft.json
    ```
3.  **Setup Backend:** Create the remote S3 bucket for state.
    ```bash
    cd .. && terraform init && terraform apply -auto-approve
    ```
4.  **Deploy Infra:** Deploy the EC2 instance and network resources.
    ```bash
    terraform init && terraform apply -auto-approve
    ```

---

## 💡 Key Features & Technologies

This solution demonstrates expertise in the following areas:

### Infrastructure as Code & State Management
* **Terraform (IaC):** Manages the entire AWS infrastructure (VPC, Networking, EIP, Security Groups).
* **S3 Backend:** Remote state storage is configured using an encrypted S3 bucket.
* **Elastic IP (EIP):** Ensures the server has a **permanent, static IP address**, allowing players to connect without relying on dynamic DNS.

### Immutable Infrastructure
* **Packer:** Used to build a **"Golden AMI"** (Amazon Machine Image) that contains the pre-installed Java runtime, Minecraft server software, and systemd service configuration.
    * **Template Path:** The Packer configuration is located at `packer/minecraft.json`.
* **World Persistence:** The Minecraft world is automatically backed up to S3. **World survives destroy — automatically restored from S3.**
* **Zero-Downtime Updates:** Any server update (e.g., changing the Minecraft version in the Packer template) triggers the creation of a brand new EC2 instance from the new AMI before destroying the old one.

### Automation & Local Tools
* **Local Automation:** Terraform uses `local-exec` to automatically update the local `~/.ssh/config` file with the EIP and SSH key path, simplifying server access.

---

## 🛠️ Prerequisites

* An AWS account with **SSO or configured profile**.
* **Terraform** ($\ge 1.0$) and **Packer** ($\ge 1.7$) installed locally.
* AWS CLI configured with a **named profile** (e.g., `my-dev-profile`).
* **IAM Role/User for Packer:** The AWS profile used by Packer must have permissions to create EC2 instances, AMIs, and manage necessary resources. **This profile name must be set by the user** in the `aws_profile` variable within the Packer template (`packer/minecraft.json`).

---

## 🚀 Deployment Instructions

### 1. Build the Golden AMI with Packer

Before deploying the EC2 instance, you must build the initial **"Golden AMI"** using Packer.

1.  Navigate to the Packer directory:
    ```bash
    cd packer
    ```
2.  **Set your AWS Profile:** Open `minecraft.json` and set your desired AWS CLI profile name in the `aws_profile` variable:
    ```json
    "aws_profile": "YOUR_AWS_PROFILE_NAME"
    ```
    *(**Note:** Replace `YOUR_AWS_PROFILE_NAME` with the name of your configured AWS CLI profile, e.g., `my-dev-profile`)*
3.  Build the AMI:
    ```bash
    packer build minecraft.json
    ```
4.  Return to the root directory:
    ```bash
    cd ..
    ```

### 2. Initialize Backend Resources (Local State)

To successfully initialize your local state and prepare the remote S3 bucket for migration:

1.  **Temporarily comment out** the `backend "s3"` block in `backend.tf`.
2.  Run the initial setup to create the remote state bucket:
    ```bash
    terraform init
    terraform apply -auto-approve
    ```

### 3. Migrate State to S3 Backend

1.  **Uncomment** the `backend "s3"` block in `backend.tf`. Ensure the `profile` is set correctly.
2.  Run the initialization command. Terraform will detect the change and prompt you to migrate the state to the S3 backend. Confirm the migration when prompted.
    ```bash
    terraform init
    ```

### 4. Deploy the Infrastructure with Terraform

Now that the AMI is built and the state is configured, deploy the EC2 instance and all supporting infrastructure.

1.  Initialize and apply the configuration:
    ```bash
    terraform init
    terraform apply -auto-approve
    ```

---

## 🔁 Updating the Server (Immutable Approach)

To update the server (e.g., change the Minecraft version or server configuration):

1.  **Update Packer Template:** Modify the configuration in `packer/minecraft.json`.
2.  **Rebuild AMI:** Run the Packer build command again (from step 1 above) to create a new AMI.
3.  **Redeploy with Terraform:** Run `terraform apply` again. Terraform will detect the new AMI ID and perform a **replacement** of the EC2 instance, implementing a zero-downtime update.

---

## 📸 Screenshots

To fully document the deployment, include the following screenshots in this section:

* Packer build output showing the **AMI ID** created.
* <img width="1131" height="562" alt="image" src="https://github.com/user-attachments/assets/065dbbb8-1248-44da-80fb-d5776f37952f" />
* Output of `terraform apply -auto-approve` showing **S3 bucket creation** during the initial setup.
* `terraform init` output showing the **prompt for state migration**.
* Final output of `terraform apply` showing the creation of the **EC2 instance** and network resources.

---

## 🧹 Cleanup

To destroy all AWS resources created by Terraform:

```bash
terraform destroy -auto-approve

# Terraform AWS IAM Management (YAML-Driven)

This project automates AWS IAM user and policy management using Terraform.
User identities and permissions are defined declaratively in YAML and enforced
using Infrastructure as Code (IaC).

---

## Architecture

```mermaid
graph TD
    subgraph "Configuration Layer (Git VCS)"
        YAML[("user.yml
        (Declarative Identity Source)")]
    end

    subgraph "Terraform Runtime Environment"
        direction TB
        Ingest["Data Ingestion
        (yamldecode)"]
        Transform["Data Normalization & Flattening
        (locals + flatten)"]
        Iterate["Dynamic Resource Iteration
        (for_each)"]

        YAML --> Ingest
        Ingest --> Transform
        Transform --> Iterate
    end

    subgraph "Target Cloud Environment (AWS IAM)"
        direction TB
        IAM_User["IAM User"]
        IAM_Policy["Policy Attachment
        (AWS Managed Policies)"]
        IAM_Profile["Login Profile
        (Lifecycle controlled)"]

        Iterate --> IAM_User
        Iterate --> IAM_Policy
        Iterate --> IAM_Profile
    end

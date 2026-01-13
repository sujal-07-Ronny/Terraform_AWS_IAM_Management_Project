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
        (locals maps / flatten logic)"]
        Iterate["Dynamic Resource Iteration
        (for_each meta-argument)"]

        YAML --> Ingest
        Ingest --> Transform
        Transform --> Iterate
    end

    subgraph "Target Cloud Environment (AWS IAM)"
        direction TB
        IAM_User["IAM User
        (Resource)"]
        IAM_Policy["Policy Attachment
        (AWS Managed Policies)"]
        IAM_Profile["Login Profile
        (w/ lifecycle rules)"]

        Iterate -- "Provision" --> IAM_User
        Iterate -- "Attach" --> IAM_Policy
        Iterate -- "Configure" --> IAM_Profile

        IAM_User -.-> IAM_Policy
        IAM_User -.-> IAM_Profile
    end



graph TD
    subgraph "Configuration Layer (Git VCS)"
        YAML[("users.yaml
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
        (w/ lifecycle lifecycle rules)"]

        Iterate -- "Provision" --> IAM_User
        Iterate -- "Attach" --> IAM_Policy
        Iterate -- "Configure" --> IAM_Profile

        IAM_User -.-> IAM_Policy
        IAM_User -.-> IAM_Profile
    end

    style YAML fill:#f9f,stroke:#333,stroke-width:2px,color:#000
    style Ingest fill:#d4e157,stroke:#333,color:#000
    style Transform fill:#d4e157,stroke:#333,color:#000
    style Iterate fill:#d4e157,stroke:#333,color:#000
    style IAM_User fill:#ff9900,stroke:#333,color:#fff
    style IAM_Policy fill:#ff9900,stroke:#333,color:#fff
    style IAM_Profile fill:#ff9900,stroke:#333,color:#fff

┌───────────────────────────────────────────┐
│           Configuration Layer              │
│        (Version Controlled in Git)         │
│                                           │
│   user.yml                                 │
│   ─ Declarative user & role definitions   │
└───────────────────────┬───────────────────┘
                        │
                        ▼
┌───────────────────────────────────────────┐
│         Terraform Runtime Layer            │
│                                           │
│   Data Ingestion                           │
│   ─ yamldecode()                           │
│                                           │
│   Data Normalization                       │
│   ─ locals + flatten()                    │
│                                           │
│   Dynamic Iteration                        │
│   ─ for_each                              │
└───────────────────────┬───────────────────┘
                        │
                        ▼
┌───────────────────────────────────────────┐
│          AWS IAM Control Plane             │
│                                           │
│   IAM Users                                │
│   ─ Dynamically provisioned                │
│                                           │
│   Policy Attachments                       │
│   ─ AWS Managed Policies                  │
│                                           │
│   Login Profiles                           │
│   ─ Controlled lifecycle rules             │
└───────────────────────────────────────────┘

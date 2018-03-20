# Improving security of Exekube on GCP

## Levels of security

### G-Suite and User Accounts

The first level of security is ultimately the level where we entrust the human users -- so two things are imporant:

- Strong passwords -- either long 16+ character strings that are commited to human memory or a long random string stored in a password tool like 1Password or iCloud Keychain.
- 2-factor authentication to leverage *something that the users must have* -- possession of their phone number -- as the security mechanism

### Service Accounts

#### Read more about GCP service accounts

- https://cloud.google.com/compute/docs/access/service-accounts
- https://cloud.google.com/iam/docs/understanding-service-accounts

# Setup an Exekube project on Google Cloud Platform

## Requirements starting from zero

- For Linux users, [Docker CE](/) and [Docker Compose](/) are sufficient
- For macOS users, [Docker for Mac](/) is sufficient
- For Windows users, [Docker for Windows](/) is sufficient

## Step-by-step instructions

1. Clone the git repo with default configuration values:

    ```bash
    git clone https://github.com/ilyasotkov/exekube \
    && cd exekube
    ```

2. Create an alias for your shell session (`xk` stands for "exekube"):

    ```bash
    alias xk=". .env && docker-compose run --rm exekube"
    ```

3. If you don't already have one, create a [Google Account](https://console.cloud.google.com/). Then, create a new [GCP Project](https://console.cloud.google.com).

    | Project name | Project ID |
    | --- | --- |
    | Production Project | production-project-20180101 |

4. Rename `.env.example` file in repo root to `.env` and set the `TF_VAR_gcp_project` variable to the value from previous step.

    ```bash
    mv .env.example .env
    ```

    ```diff
    export XK_LIVE_DIR='/exekube/live/prod'
    - export TF_VAR_gcp_project='my-project-186217'
    + export TF_VAR_gcp_project='production-project-20180101'
    export TF_VAR_gcp_remote_state_bucket='project-terraform-state'
    ```

5. [Create a service account](https://console.cloud.google.com/projectselector/iam-admin/serviceaccounts) and give it project owner permissions. A JSON private key file will be downloaded onto your machine, which you'll need to move into `live/prod` (the deployment environement directory) and rename the file to `owner-key.json`.

    ![Creating a GCP service account in GCP Console](img/gcp-sa.png)
    ![JSON key in the deployment environment directory](img/dir.png)

6. Finally, use the JSON key to authenticate to the Google Cloud SDK and create a Google Cloud Storage bucket (with versioning) for our Terraform remote state:

    ```bash
    xk gcloud auth activate-service-account \
            --key-file live/prod/owner-key.json \
    && xk gsutil mb \
            -p ${TF_VAR_gcp_project} \
            gs://${TF_VAR_gcp_remote_state_bucket} \
    && xk gsutil versioning set on \
            gs://${TF_VAR_gcp_remote_state_bucket}
    ```

You deployment environment on the Google Cloud Platform is now ready!

## Up next

- [Tutorial: deploy an application on Kubernetes with Exekube](/usage/deploy-app)
- [Guide to Exekube directory structure and framework usage](/usage/directory-structure)

# Setup a project space on Google Cloud Platform

## Requirements starting from zero

- For Linux users, [Docker CE](/) and [Docker Compose](/) are sufficient
- For macOS users, [Docker for Mac](/) is sufficient
- For Windows users, [Docker for Windows](/) is sufficient

## Step-by-step instructions

1. Clone the example project ([internal-ops-project](https://github.com/exekube/internal-ops-project)) git repo:

    ```bash
    git clone https://github.com/exekube/internal-ops-project \
    && cd exekube
    ```

2. Create a bash alias for your shell session (`xk` stands for "exekube"):

    ```bash
    alias xk="docker-compose run --rm exekube"
    ```

3. If you don't already have one, create a [Google Account](https://console.cloud.google.com/). Then, create a new [GCP Project](https://console.cloud.google.com).

    | Project name | Project ID |
    | --- | --- |
    | Production Project | production-project-20180101 |

4. Set the variables for your environment in `live/prod/.env`:

    ```sh
    GOOGLE_CREDENTIALS=/project/live/prod/secrets/sa-key.json
    TF_VAR_xk_live_dir=/project/live/prod
    TF_VAR_gcp_project=production-project-20180101
    TF_VAR_gcp_remote_state_bucket=production-project-20180101-tfstate
    ```

5. [Create a service account](https://console.cloud.google.com/projectselector/iam-admin/serviceaccounts) and give it project owner permissions. A JSON-econded private key file will be downloaded onto your machine, which you'll need to move into `live/prod/secrets/` directory and rename to `sa-key.json`.

    ![Creating a GCP service account in GCP Console](img/gcp-sa.png)

6. Finally, use the key to authenticate to the Google Cloud SDK and create a Google Cloud Storage bucket (with versioning) for our Terraform remote state:

    ```bash
    chmod 600 live/prod/secrets/sa-key.json \
    && xk gcloud auth activate-service-account \
            --key-file live/prod/secrets/sa-key.json \
    && xk gsutil mb \
            -p $TF_VAR_gcp_project \
            gs://$TF_VAR_gcp_remote_state_bucket \
    && xk gsutil versioning set on \
            gs://$TF_VAR_gcp_remote_state_bucket
    ```

✅ You project space on the Google Cloud Platform is now ready!

## Up next

- [Tutorial: deploy an application on Kubernetes with Exekube](/usage/deploy-app)
- [Guide to Exekube directory structure and framework usage](/usage/directory-structure)

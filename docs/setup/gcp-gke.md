# Setup a project space on Google Cloud Platform

## Requirements starting from zero

- For Linux users, [Docker CE](/) and [Docker Compose](/) are sufficient
- For macOS users, [Docker for Mac](/) is sufficient
- For Windows users, [Docker for Windows](/) is sufficient

## Step-by-step instructions

1. Clone the example project ([internal-ops-project](https://github.com/exekube/internal-ops-project)) git repo:

    ```bash
    git clone https://github.com/exekube/internal-ops-project \
    && cd internal-ops-project
    ```

2. Create a bash alias for your shell session (`xk` stands for "exekube"):

    ```bash
    alias xk="docker-compose run --rm exekube"
    ```

3. Set the variables for your environment in `live/prod/.env`:

    ```sh
    # GOOGLE_CREDENTIALS=/project/live/prod/secrets/sa/owner.json

    TF_VAR_xk_live_dir='/project/live/prod'
    TF_VAR_gcp_organization='889071810646'
    TF_VAR_gcp_billing_id='327BDY-9FAAFB-40FF75'
    TF_VAR_gcp_project='prod-my-internal-ops'
    TF_VAR_gcp_remote_state_bucket='prod-my-internal-ops-tfstate'
    ```

4. Then, you'll need to create a new GCP Project and enable billing for it:

    ```bash
    gcloud projects create $TF_VAR_gcp_project \
        --organization=$TF_VAR_gcp_organization \
    && gcloud beta billing projects link $TF_VAR_gcp_project \
        --billing-account $TF_VAR_gcp_billing_id
    ```

5. Create a service account for Terraform and give it appropriate permissions:

    ```sh
    gcloud iam service-accounts create terraform \
        --project=$TF_VAR_gcp_project \
        --display-name "Terraform admin account"
    ```
    ```sh
    gcloud organizations add-iam-policy-binding $TF_VAR_gcp_organization \
        --member serviceAccount:terraform@$TF_VAR_gcp_project.iam.gserviceaccount.com \
        --role roles/resourcemanager.projectCreator
    ```
    ```sh
    gcloud organizations add-iam-policy-binding $TF_VAR_gcp_organization \
        --member serviceAccount:terraform@$TF_VAR_gcp_project.iam.gserviceaccount.com \
        --role roles/billing.user
    ```
    ```sh
    gcloud projects add-iam-policy-binding $TF_VAR_gcp_project \
        --member serviceAccount:terraform@$TF_VAR_gcp_project.iam.gserviceaccount.com \
        --role roles/owner
    ```
    ```sh
    gcloud iam service-accounts keys create \
        --project=$TF_VAR_gcp_project \
        --key-file-type json \
        --iam-account terraform@$TF_VAR_gcp_project.iam.gserviceaccount.com \
        ./live/prod/secrets/sa/owner.json
    ```

6. Finally, use the key to authenticate to the Google Cloud SDK and create a Google Cloud Storage bucket (with versioning) for our Terraform remote state:

    ```bash
    chmod 600 live/prod/secrets/sa/owner.json \
    && xk gcloud auth activate-service-account \
            --key-file live/prod/secrets/sa/owner.json \
    && xk gsutil mb \
            -p $TF_VAR_gcp_project \
            gs://$TF_VAR_gcp_remote_state_bucket \
    && xk gsutil versioning set on \
            gs://$TF_VAR_gcp_remote_state_bucket
    ```

!!! tip
    DNS and a static IP for our cluster ingress-controller are currently created outside of Terraform, using `gcloud`:

    ```sh
    gcloud dns managed-zones create examplezonename --description="Example Zone" \
        --dns-name="example.zone.com."
    ```
    ```sh
    gcloud dns record-sets export records.yaml --zone examplezonename
    ```
    ```sh
    gcloud dns record-sets import records.yaml --zone examplezonename
    ```

    ```sh
    gcloud compute addresses create [ADDRESS_NAME] \
        [--region [REGION] | --global ] \
        [--ip-version [IPV4 | IPV6]]
    ```

✅ Your project space on the Google Cloud Platform is now ready!

## Up next

- [Tutorial: deploy an application on Kubernetes with Exekube](/usage/deploy-app)
- [Guide to Exekube directory structure and framework usage](/usage/directory-structure)

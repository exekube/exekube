# Deploy all infrastructure and a custom application to Kubernetes

1. Set up the example internal-ops-project:

    - [Create an Exekube project on Google Cloud Platform](/setup/gcp-gke)

2. Customize the code in `live/prod`:

    - [Configure a Helm release](/misc/configure-helm-release/)
    - [Add secrets for the environment](/misc/secrets/)

3. Apply all *Terraform live modules* — create all cloud infrastructure and all Kubernetes resources:

    ```diff
    xk up
    ```

4. Enable the Kubernetes dashboard at <http://localhost:8001/ui>:

    ```sh
    docker-compose up -d
    ```

5. Go to <https://my-app.YOURDOMAIN.COM/> to check that a hello-world Rails app is running.
6. Change the Rails application container image version in [live/prod/releases/rails-app/values.yaml](/):

    ```diff
     replicaCount: 2
     image:
       repository: ilyasotkov/rails-react-boilerplate
    -  tag: "1.0.0"
    +  tag: "1.0.1"
       pullPolicy: Always
    ```

    Upgrade the state of real-world cloud resources to the state of our code in `live/prod` directory:
    ```bash
    xk up
    ```
    Now, go back to your browser and check how your app updated with zero downtime! 😎

7. Experiment with creating, upgrading, and destroying single live modules and groups of live modules:

    ```bash
    xk down live/prod/releases/rails-app/

    xk up live/prod/releases/rails-app/
    xk up live/prod/releases/some-other-app/
    ```

8. Clean everything up (destroy all cloud provider and Kubernetes resources):

    ```sh
    xk down
    ```

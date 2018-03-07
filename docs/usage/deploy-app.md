# Deploy an application on Kubernetes with Exekube

!!! warning
    This article is incomplete. Want to help? [Submit a pull request](https://github.com/ilyasotkov/exekube/pulls).

1. Edit code in [`live`](/):

    !!! important
        If you cloned / forked this repo, you'll need to have a domain name (DNS zone) like `example.com` and have CloudFlare DNS servers set up for it. Then, in your text editor, search and replace `swarm.pw` with your domain zone.

    [Guide to Terraform / Terragrunt, HCL, and Exekube directory structure](/)

2. Apply all *Terraform live modules* — create all cloud infrastructure and all Kubernetes resources:

    ```diff
    xk apply
    + ...
    + Module /exekube/live/prod/kube/apps/rails-app has finished successfully!
    ```

3. Enable the Kubernetes dashboard at <http://localhost:8001/ui>:

    ```sh
    docker-compose up -d
    ```

4. Go to <https://my-app.YOURDOMAIN.COM/> to check that a hello-world Rails app is running.
5. Upgrade the Rails application Docker image version in [live/kube/apps/my-app/values.yaml](/):

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
    xk apply
    ```
    Go back to your browser and check how your app updated with zero downtime! 😎

6. Experiment with creating, upgrading, and destroying single live modules and groups of live modules:

    ```bash
    xk destroy live/prod/kube/apps/rails-app/
    xk destroy live/prod/kube/apps/

    xk apply live/prod/kube/
    xk apply live/prod/kube/apps/rails-app/
    ```

7. Clean everything up:

    ```sh
    # Destroy all cloud provider and Kubernetes resources
    xk destroy
    ```

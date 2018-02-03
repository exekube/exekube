# CircleCI 2.0 Pipeline for deploying whole cloud environments

This is a simple pipeline that uses the `ilyasotkov/exekube:latest` from DockerHub.

We import all secrets via base64-encoded environmental variables, save them to files, and finally run the equivalent of local `xk apply` and `xk destroy`.

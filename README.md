# sre-infra
Tmc2 SRE code challenge

# SRE Technical Task: Deploying a Custom Docker Image Using Argo CD

## Overview

In this technical task, you will be performing a series of actions that are a part of typical SRE responsibilities. You will be preparing a custom Docker image and using Argo CD to deploy it.

## Objectives

1. Prepare a Custom Docker Image.
   We want you to create a custom image using as base the [official Nginx image](https://hub.docker.com/_/nginx) for serving a static txt file containing the text "Hello World" and your name. Please adapt it to Docker image build best practices.
2. Deploy the Custom Docker Image to a registry using CI.
   Using the CI tool of your preference (GitHub Actions for example), create pipeline configurations files with basic validations and push to an Docker Registry of any kind.
3. Deploy Argo CD to a Kubernetes Cluster.
   Using the official [helm chart for ArgoCD](https://artifacthub.io/packages/helm/argo/argo-cd) provide the yaml files to deploy an ArgoCD instance in Kubernetes. Minikube or similar tools must be used for testing this deployment.
4. Deploy the Custom Docker Image Using Argo CD.
   Create some manifests to deploy in the kubernetes cluster the Custom Docker Image using ArgoCD. Configure 2 replicas for the service.

## Deliverables

Upon completion, we expect you to provide:

- The Dockerfile you created.
- CI pipeline configurations and scripts.
- The Argo CD application manifests.
- Custom Image deployment manifests.
- A brief walkthrough of the steps you took. Please add some screenshots.


## Walkthrough

Objective 1:

- Create the static file in html/index.txt.
- Create the dockerfile with basic configuration.
- Build the docker image and run the docker container with latest tag:
  `docker build -t nginx-custom-image:latest .` and `docker run -d -p 8080:80 nginx-custom-image:latest ` 
- Check on http://localhost:8080/index.txt as shown below:
![hello_world](https://github.com/r3b0rNjHs/sre-infra/raw/main/images/hello_world.jpg)

Objective 2:

- Add docker hub user and password credentials to the github repository secrets.
- Create the github action workflow yml inside of folder .github/workflows.
- Commit push and check in the github repository action web the workflow:
![github_action](https://github.com/r3b0rNjHs/sre-infra/raw/main/images/github_action.jpg)
- verify in dockerhub that the docker image have being correctly pushed:
![verify](https://github.com/r3b0rNjHs/sre-infra/raw/main/images/verify_nginx_image.jpg)

Objective 3:

- Add Argo CD Helm repository to Helm (after installing minikube and helm, and starting minikube): `helm repo add argo-cd https://argoproj.github.io/argo-helm `
- Create a values.yaml file with basic Argo CD configuration.
- Install Argo CD using Helm: ` helm install argocd argo-cd/argo-cd -f values.yaml ` in this case i will run it on the default namespace.
- Run the server with: `kubectl port-forward svc/argocd-server 8080:443`.
![argocd_basic](https://github.com/r3b0rNjHs/sre-infra/raw/main/images/argocd_basic.jpg)
- Log in with admin and the initial password, the password can be get with: `kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`.
- Notice that it is a initial set up password that is highly recommended to be changed, for this example i just retrieved it and use it.
- After log in this will be what will be prompt in the web:
![argocd_home](https://github.com/r3b0rNjHs/sre-infra/raw/main/images/argocd_home.jpg)

Objective 4:

- Create the k8s deployment yaml (here we will be adding as a spec the 2 desired replicas), the k8s service yaml and the Argo CD app yaml.
- Apply the manifests to the k8s cluster: `kubectl apply -f argocd/custom-deployment.yaml` and `kubectl apply -f argocd/custom-service.yaml`.
- Apply the Argo CD manifest: `kubectl apply -f argocd/argo-cd-application.yaml`.
- Final result shown below:
![argocd_app](https://github.com/r3b0rNjHs/sre-infra/raw/main/images/argocd_app.png)
![argocd_app_details](https://github.com/r3b0rNjHs/sre-infra/raw/main/images/argocd_app_details.png)

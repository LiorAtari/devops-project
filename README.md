# DevOps Project - Develeap

This repository contains everything you need to deploy a Python web application on Google Kubernetes Engine (GKE) using Terraform, Helm, and ArgoCD.

## Project Structure

- **`terraform/`**: Contains Terraform code to provision the cloud infrastructure on GCP, including:
  - **Google GKE**: Kubernetes cluster where the microservices are deployed.
  - **VPC network and subnet**: Networking for the GKE cluster
  - **Kubernetes secrets**: Used to inject the secrets from GCP Secret Manager to the cluster securely
  - **ArgoCD and ArgoCD-Apps**: Used for continuous deployment of the microservices, deployed via Helm.

- **`python-application/`**: Includes the application's source code and Dockerfile
 
- **`python-chart/`**: Contains the Helm chart with the kubernetes manifests for deploying the python-application on the cluster

- **`.github/workflows/`**: Includes the GitHub Action used to build and tag Docker image for the python-app and pushes it to DockerHub. The new image version is then written to the repo's Helm chart


## Prerequisites

Before running Terraform, make sure you have:

- A GCP project with billing enabled.
- The following tools installed:
   - [Terraform](https://developer.hashicorp.com/terraform/downloads)
   - [gcloud SDK](https://cloud.google.com/sdk/docs/install)
   - [kubectl](https://kubernetes.io/docs/tasks/tools/)
   - [helm](https://helm.sh/docs/intro/install/)


Before running the Terraform code in `02-kubernetes-resources`:
- Ensure the following **two secrets** are created in GCP Secret Manager from the secret shared with you securely

   - `devops-project-repo-ssh-key`: The SSH private key that ArgoCD will use to access your Git repository.
   - `mysql-secrets`: A secret containing your MySQL credentials in JSON or plain format.

## GCP Secret Creation

Create the secrets in GCP (replace <path to *>):

```bash
# For the SSH private key
gcloud secrets create devops-project-repo-ssh-key --data-file=<path to devops-project-repo-ssh-key>

# For MySQL secrets
gcloud secrets create mysql-secrets --data-file=<path to mysql-secrets.yaml>
```

## How to Use
1. **Clone the Repository:**
```bash
git clone git@github.com:LiorAtari/devops-project.git
cd devops-project/terraform/
```
2. **GKE cluster setup (~15 minutes to finish):**
```bash
cd 01-gke-cluster
terraform init
terraform plan
terraform apply
```
3. **Kubernetes resources setup (ArgoCd, helm, etc.):**
```bash
cd ../02-kubernetes-resources
terraform init
terraform plan
terraform apply
```
4. **Run the script**  
Once terraform finishes provisioning everything, run the following commands:
```bash
cd ../..
chmod +x run.sh
./run.sh

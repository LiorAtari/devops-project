# DevOps Project - Develeap

This repository contains everything you need to deploy the Python web application on Google Kubernetes Engine (GKE) using Terraform, Helm, and ArgoCD.

## Project Structure

- **`terraform/`**: Contains Terraform code to provision the cloud infrastructure on GCP, including:
  - **Google GKE**: Kubernetes cluster where the microservices are deployed.
  - **VPC network and subnet**: Networking for the GKE cluster
  - **Kubernetes secrets**: Used to inject the secrets from GCP Secret Manager to the cluster securely
  - **ArgoCD and ArgoCD-Apps**: Used for continuous deployment of the microservices, deployed via Helm.

- **`python-application/`**: Includes the application's source code and Dockerfile
 
- **`python-chart/`**: Contains the Helm chart with the kubernetes manifests for deploying the python-application on the cluster

- **`.github/workflows/`**: Includes the GitHub Action used to build and tag the Docker image for the python-app and pushes it to DockerHub. The new image version is then written to the repo's Helm chart


## Prerequisites

Before running Terraform, make sure you have:

- A GCP project with billing enabled.
- The following tools installed:
   - [Terraform](https://developer.hashicorp.com/terraform/downloads)
   - [gcloud SDK](https://cloud.google.com/sdk/docs/install)
   - [kubectl](https://kubernetes.io/docs/tasks/tools/)
   - [helm](https://helm.sh/docs/intro/install/)

### NOTE – Before Beginning Infrastructure Provisioning
Please update the `project` default value inside the "variables.tf" file with your project name in the following folders:
- `01-gke-cluster`
- `02-kubernetes-resources`

```
variable "project" {
  default = "develeap-task" # <--- Update this
  type    = string
}
```

Also, this project requires the creation of two GCP secrets in Secret Manager prior to running Terraform.  
Both secrets were shared securely via email.  
- ArgoCD requires an SSH key to access this repository as it is private.
- MySQL is provisioned with a custom user called "flaskapp". This is done through a secret in K8s taken from GCP

Required secret names: 
- `devops-project-repo-ssh-key`
- `mysql-secrets`

### GCP Secret Creation

Create 2 files -
- repo-ssh-key
- mysql-users

Paste the content of the secrets provided in the email into their respective files.  
**Create the secrets in GCP (replace <path to *> with the actual path to file from the previous step):***

```bash
# For the SSH private key
gcloud secrets create devops-project-repo-ssh-key --data-file=<path to repo-ssh-key>

# For MySQL secrets
gcloud secrets create mysql-secrets --data-file=<path to mysql-users>
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
./run.sh --project <your-project-id>

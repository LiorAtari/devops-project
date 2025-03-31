#!/bin/bash

# Require user to provide the GCP project ID
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --project)
            PROJECT="$2"
            shift 2
            ;;
        *)
            echo "Unknown parameter passed: $1"
            echo "Usage: $0 --project <gcp-project-id>"
            exit 1
            ;;
    esac
done

# Validate input
if [[ -z "$PROJECT" ]]; then
    echo "Missing required argument: --project"
    echo "Usage: $0 --project <gcp-project-id>"
    exit 1
fi

gcloud container clusters get-credentials lior-cluster --region us-central1 --project "$PROJECT"

ARGOCD_PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode)

# Run Argo CD port-forward to access at localhost:8080
echo "Starting port forwarding for Argo CD server on port 8080"
kubectl -n argocd port-forward deployment/argocd-server 8080 > /dev/null 2>&1 &
ARGOCD_PORT_FORWARD_PID=$!
# Wait a few seconds to ensure port-forward is established
sleep 3
echo -e "To access ArgoCD, browse to 'http://localhost:8080'\n"


get_python_pod_status() {
    echo "Waiting for the Python app pod to become ready..."
    kubectl -n python-app wait --for=condition=ready pod -l app.kubernetes.io/instance=python-app --timeout=300s
}

# Wait for the pod to be ready
if get_python_pod_status; then
    # Run port-forwarding once ready
    kubectl -n python-app port-forward deployment/python-app 8081 > /dev/null 2>&1 &
    PYTHON_APP_PORT_FORWARD_PID=$!
    sleep 3
    echo -e "To access the Python app, browse to: http://localhost:8081\n"
else
    echo "Pod did not become ready in time. Exiting."
    exit 1
fi

echo "To kill the port-forwarding process of ArgoCD and the Python app -"
echo -e "run the following commands:\n"
echo -e "kill $ARGOCD_PORT_FORWARD_PID"
echo -e "kill $PYTHON_APP_PORT_FORWARD_PID\n"
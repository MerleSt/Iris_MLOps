#!/bin/bash
# Setup script: prepares the codespace environment for the iris MLOps project.
# Run this after restarting a stopped codespace.

set -e  # exit immediately if any command fails

CLUSTER_NAME="iris-cluster"

# Step 1: does the cluster exist AND is it reachable?
if kind get clusters | grep -q "^${CLUSTER_NAME}$" && kubectl cluster-info --context "kind-${CLUSTER_NAME}" > /dev/null 2>&1; then
    echo "    Cluster '${CLUSTER_NAME}' exists and is reachable."
else
    # If it exists but is unreachable, delete it first
    if kind get clusters | grep -q "^${CLUSTER_NAME}$"; then
        echo "    Cluster '${CLUSTER_NAME}' exists but is unreachable. Deleting it..."
        kind delete cluster --name "${CLUSTER_NAME}"
    fi
    echo "    Creating cluster '${CLUSTER_NAME}'..."
    kind create cluster --name "${CLUSTER_NAME}"
fi

echo "==> Verifying cluster is reachable..."
kubectl get nodes

echo "==> Setting up ArgoCD..."

# Create the argocd namespace if it doesn't exist
if ! kubectl get namespace argocd > /dev/null 2>&1; then
    echo "    Creating 'argocd' namespace..."
    kubectl create namespace argocd
fi

# Install or update ArgoCD
echo "    Installing/updating ArgoCD (this can take a minute)..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml --server-side --force-conflicts

echo "    Waiting for ArgoCD pods to be ready..."
kubectl wait --for=condition=available --timeout=300s -n argocd deployment --all

echo "==> Applying Kubernetes manifests..."
kubectl apply -f k8s/

echo "==> Waiting for deployment to be ready..."
kubectl wait --for=condition=available --timeout=60s deployment/iris-deployment

echo ""
echo "==> Setup complete."
echo "==> To reach the service in the browser, run:"
echo "    kubectl port-forward service/iris-service 8000:80"
echo "==> Then visit the forwarded URL with /docs appended."
echo "==> Don't forget to: docker login -u merlest"
#!/bin/bash
# Setup script: prepares the codespace environment for the iris MLOps project.
# Run this after restarting a stopped codespace.

set -e  # exit immediately if any command fails

echo "==> Checking kind cluster..."
if kind get clusters | grep -q "iris-cluster"; then
    echo "    Cluster 'iris-cluster' already exists."
else
    echo "    Cluster not found. Creating it now..."
    kind create cluster --name iris-cluster
fi

echo "==> Verifying cluster is reachable..."
kubectl get nodes

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
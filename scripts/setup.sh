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

echo ""
echo "==> Setup complete."
echo "==> Don't forget to: docker login -u merlest"
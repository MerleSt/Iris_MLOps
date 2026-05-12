# Iris MLOps Demo

A small project demonstrating a full MLOps workflow: train a simple machine learning model, expose it as a REST API with FastAPI, containerize it with Docker, deploy it to Kubernetes, and automate the build pipeline with GitHub Actions.

## What this project does

Trains a Logistic Regression model on the classic Iris dataset and serves predictions over HTTP. The model itself is intentionally trivial — the focus of the project is the surrounding infrastructure (containerization, deployment, automation).

## Tech stack

- **Python** with FastAPI and scikit-learn
- **Docker** for containerization
- **Docker Hub** for the image registry
- **Kubernetes** (via `kind`) for deployment
- **GitHub Actions** for CI/CD (automated build and push)
- **GitHub Codespaces** for development environment

## Project structure

```
iris-mlops-demo/
├── .github/workflows/    # GitHub Actions CI/CD pipelines
│   └── build-and-push.yml
├── app/                  # FastAPI application
│   ├── main.py           # API endpoints
│   └── model.py          # Model loading and prediction wrapper
├── k8s/                  # Kubernetes manifests
│   ├── deployment.yml
│   └── service.yml
├── scripts/              # Setup and utility scripts
│   └── setup.sh          # Restores cluster after codespace restart
├── train.py              # Trains the model and saves it to disk
├── requirements.txt      # Python dependencies
├── Dockerfile            # Container build instructions
├── .dockerignore         # Files Docker should skip when building
└── README.md             # This file
```

## How it all fits together

1. `train.py` trains a model and saves it as `model.joblib`
2. `app/model.py` defines `IrisClassifier`, which loads the saved model
3. `app/main.py` exposes the classifier as a FastAPI service
4. `Dockerfile` packages everything into a portable container image
5. `.github/workflows/build-and-push.yml` automatically builds and pushes the image to Docker Hub on every push to `main`
6. `k8s/deployment.yml` and `k8s/service.yml` deploy the image to a local Kubernetes cluster
7. `scripts/setup.sh` rebuilds the cluster from manifests if the codespace restarts

## Getting started

### After restarting the codespace

```bash
./scripts/setup.sh
```

The setup script makes sure the kind cluster is running and reapplies the manifests. Docker Hub login is only needed if pushing images manually (the GitHub Actions workflow handles automated pushes).

### Useful commands

**Train the model:**
```bash
python train.py
```

**Run the API locally (without containers):**
```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

Then visit `/docs` on the forwarded port.

**Build the Docker image locally:**
```bash
docker build -t iris-mlops:v1 .
```

**Run the image as a container locally:**
```bash
docker run -d -p 8000:8000 --name iris-service iris-mlops:v1
```

**Stop and remove the container:**
```bash
docker stop iris-service
docker rm iris-service
```

### Kubernetes commands

The setup script applies the manifests automatically. For reference:

**Apply all manifests in the k8s/ folder:**
```bash
kubectl apply -f k8s/
```

**See running deployments, pods, and services:**
```bash
kubectl get deployments
kubectl get pods
kubectl get services
```

**View logs from your pod:**
```bash
kubectl logs -l app=iris
```

**Forward the service to port 8000 (run in a separate terminal):**
```bash
kubectl port-forward service/iris-service 8000:80
```

Then open the forwarded URL with `/docs` appended.

**Delete everything when done:**
```bash
kubectl delete -f k8s/
```

### CI/CD pipeline

A GitHub Actions workflow at `.github/workflows/build-and-push.yml` runs on every push to `main`. It:

1. Checks out the code on a fresh Linux runner
2. Logs in to Docker Hub using stored secrets
3. Builds a Docker image from the Dockerfile
4. Pushes the image to Docker Hub with two tags: `latest` and the commit SHA

The image is publicly available at `hub.docker.com/r/merlest/iris-mlops`.

## Public artifacts

- **Source code:** this repository
- **Docker image:** [hub.docker.com/r/merlest/iris-mlops](https://hub.docker.com/r/merlest/iris-mlops)
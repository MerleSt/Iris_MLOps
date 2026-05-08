# Iris MLOps Demo

A small project demonstrating the full MLOps workflow: train a simple machine learning model, expose it as a REST API with FastAPI, containerize it with Docker, and deploy it to Kubernetes.

## What this project does

Trains a Logistic Regression model on the classic Iris dataset and serves predictions over HTTP. The model itself is intentionally trivial — the focus of the project is the surrounding infrastructure (containerization, deployment, automation).

## Tech stack

- **Python** with FastAPI and scikit-learn
- **Docker** for containerization
- **Docker Hub** for the image registry
- **Kubernetes** (via `kind`) for deployment
- **GitHub Codespaces** for development environment

## Getting started

### After restarting the codespace

```bash
./scripts/setup.sh
docker login -u merlest
```

The setup script makes sure the kind cluster is running and reachable. The Docker login is needed because credentials don't persist across codespace restarts.

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

**Build the Docker image:**
```bash
docker build -t iris-mlops:v1 .
```

**Run the image as a container:**
```bash
docker run -d -p 8000:8000 --name iris-service iris-mlops:v1
```

**Stop and remove the container:**
```bash
docker stop iris-service
docker rm iris-service
```

**Push the image to Docker Hub:**
```bash
docker tag iris-mlops:v1 merlest/iris-mlops:v1
docker push merlest/iris-mlops:v1
```

### Kubernetes commands

(To be filled in as we work through Stage 4.)

## Project structure

```
iris-mlops-demo/
├── app/                  # FastAPI application
│   ├── main.py           # API endpoints
│   └── model.py          # Model loading and prediction wrapper
├── k8s/                  # Kubernetes manifests
│   └── deployment.yml
├── scripts/              # Setup and utility scripts
│   └── setup.sh          # Restores cluster after codespace restart
├── train.py              # Trains the model and saves it to disk
├── requirements.txt      # Python dependencies
├── Dockerfile            # Container build instructions
├── .dockerignore         # Files Docker should skip when building
└── README.md             # This file
```

## Public artifacts

- **Source code:** github.com/yourusername/iris-mlops-demo
- **Docker image:** hub.docker.com/r/merlest/iris-mlops
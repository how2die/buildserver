# Build Server

Continuous delivery using [Jenkins](https://jenkins.io/) to automate builds and deployment.

## Getting started

Deployment to Kubernetes cluster and basic configuration.

### Prerequisites

* A Kubernetes cluster
* kubectl

### Deploying to Kubernetes

First, set up a persistent volume for plugins, configurations, job data, etc.
```
kubectl apply -f pvc.yaml
```

Create a service account that grants Jenkins permissions to deploy to Kubernetes
```
kubectl apply -f service-account.yaml
```

Set up a DaemonSet running the Docker daemon and mounting the Docker daemon socket to a volume on the node. This ensures that every container may get access to a Docker daemon, and allows use of Docker-in-Docker (DinD)
```
kubectl apply -f dind.yaml
```

Finally, create the Service and Deployment
```
kubectl apply -f deployment.yaml
```

### Installing Jenkins

When the Jenkins pod has started up for the first time, you may find the admin password in the log
```
kubectl logs -l app=jenkins
```

Open the Jenkins dashboard in a browser, enter admin password, and install suggested plugins. Update Jenkins to newest version.

### Configuration

Store Docker repository credentials:

Credentials -> global -> Add Credentials -> Username with password -> ID = docker-hub

Install the Kubernetes plugin, then configure at:
Manage Jenkins -> Manage Nodes and Clouds -> Configure Clouds -> Add a new cloud -> Kubernetes

Set Jenkins tunnel to jenkins:50000.
Click "Test Connection" to test the connection.


## Adding a project
Enable automatic builds and deployment for a project

### Create the pipeline
1. Create a new Multibranch pipeline
2. Under "Branch Sources", choose "Add Source"
    1. Choose "Git"
    2. Enter Project Repository 
3. Optional: Scan Multibranch Pipeline Triggers at a given interval

### Add a git webhook
Add a webhook in the git repository to be triggered by the *push* event.
The webhook should send a POST request to *https://[jenkins url]/git/notifyCommit?url=[repository url]*

## Enjoy!

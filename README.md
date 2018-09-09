# Build Server

Continuous delivery using [Jenkins](https://jenkins.io/) to automate builds and deployment.

## Getting Started

Deployment to Kubernetes cluster and basic configuration.

### Prerequisites

* A Kubernetes cluster
* kubectl
* Docker

### Deploying to Kubernetes

First, set up a persistent volume for plugins, configurations, job data, etc.
```
kubectl apply -f pv.yaml
```

Create a service account that grants Jenkins permissions to deploy to Kubernetes
```
kubectl apply -f service-account.yaml
```

Set up a DaemonSet running the Docker daemon and mounting the Docker daemon socket to a volume on the node. This ensures that every container may get access to a Docker daemon, and allows use of Docker-in-Docker (DinD)
```
kubectl apply -f dind.yaml
```

Jobs may require Docker repository credentials to push images. These may be stored as secrets and injected into the container as environment variables
```
kubectl create secret generic docker-secret --from-literal=username='<username>' --from-literal=password='<password>' --from-literal=registry='docker.io'
```

Finally, create the Service and Deployment
```
kubectl apply -f deployment.yaml
```

### Installing Jenkins

When the Jenkins pod has started up for the first time, you can find the admin password in the log
```
kubectl logs -l app=jenkins
```

Open the Jenkins dashboard in browser, enter admin password, and install suggested plugins. Update Jenkins to newest version.

### Configuration

To hide the Docker password from output in the console, we may store and use it as a Credential:
Credentials -> global -> Add Credentials -> Secret text -> Secret=*[password]*, ID=docker-password

## Adding a project
Enable automatic builds and deployment for a project

### Create the pipeline
* Create a new Multibranch pipeline
* Under "Branch Sources", choose "Add Source"
  * Choose "Git"
  * Enter Project Repository 
* Optional: Scan Multibranch Pipeline Triggers at some given interval

### Add a git webhook
Add a webhook in the git repository to be triggered by the *push* event.
The webhook should send a POST request to https://*[jenkins url]*/git/notifyCommit?url=*[repository url]*

## Enjoy!

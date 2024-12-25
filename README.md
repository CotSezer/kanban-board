# Deployment Guide for Kubernetes with Locust and GCP

This guide details the deployment process for a Kubernetes cluster on Google Cloud Platform (GCP) using `gcloud`, `kubectl`, and Locust for load testing.

---

## Prerequisites

- Google Cloud SDK (`gcloud`) installed on your local machine.
- `kubectl` installed for Kubernetes cluster management.
- Locust installed for load testing.
- A GCP account and project ready for deployment.

---

## Step-by-Step Deployment

### 0. Ensure you are in the correct directory: ./k8s.

   ```bash
   cd ./k8s
   ```

### 1. Configure GCP Project

1. Check the current GCP project configuration:

   ```bash
   gcloud auth login
   ```

2. Log in to your GCP account:

   ```bash
   gcloud config list project
   ```

3. Set the desired GCP project:

   ```bash
   gcloud config set project gcplearn-444704
   ```

4. Enable Kubernetes Engine API:

   ```bash
   gcloud services enable container.googleapis.com
   ```

---

### 2. Create and Configure Kubernetes Cluster

1. Create a Kubernetes cluster:

   ```bash
   gcloud container clusters create cluster-demo        --zone us-central1-a        --num-nodes 3
   ```

2. Authenticate `kubectl` to the cluster:

   ```bash
   gcloud container clusters get-credentials cluster-demo --zone us-central1-a
   ```

3. Verify the cluster nodes:

   ```bash
   kubectl get nodes
   ```

4. List the available Kubernetes contexts:

   ```bash
   kubectl config get-contexts
   ```

---

### 3. Deploy Application to Kubernetes

1. Apply the deployment configuration:

   ```bash
   kubectl apply -f kanban-deployment.yaml
   ```

2. Apply the service configuration:

   ```bash
   kubectl apply -f kanban-service.yaml
   ```

3. Apply the Horizontal Pod Autoscaler (HPA) configuration:

   ```bash
   kubectl apply -f kanban-hpa.yaml
   ```

4. Monitor the deployment:

   - Pods:
     ```bash
     kubectl get pods
     kubectl get pods -w
     ```
   - Services:
     ```bash
     kubectl get services
     kubectl get services -w
     ```
   - Horizontal Pod Autoscaler:
     ```bash
     kubectl get hpa -w
     ```

---

### 4. Set Up Locust for Load Testing

1. Delete the existing Locust configuration map if it exists:

   ```bash
   kubectl delete configmap locustfile-config
   ```

2. Ensure that the correct endpoints are defined in your `locustfile.py`.

3. Create a new Locust configuration map:

   ```bash
   kubectl create configmap locustfile-config --from-file=locustfile.py
   ```

4. Deploy Locust master and worker configurations:

   - Locust master:
     ```bash
     kubectl apply -f locust-master.yaml
     ```
   - Locust worker:
     ```bash
     kubectl apply -f locust-worker.yaml
     ```

---

## Verification

- Verify the deployment by accessing the services and observing logs.
- Monitor the pods and services to ensure they are functioning as expected.
- Use Locust's web interface to perform load testing and monitor results.

---

## Cleanup

To clean up the cluster and associated resources:

1. Delete the Kubernetes cluster:

   ```bash
   gcloud container clusters delete cluster-demo --zone us-central1-a
   ```

2. Delete other resources such as ConfigMaps, services, and deployments if necessary.

---

## Notes

- Replace placeholder values such as project ID and file names with your actual configuration.
- Ensure all YAML configuration files (`kanban-deployment.yaml`, `kanban-service.yaml`, etc.) are properly defined before deployment.
- Use GCP's Cloud Console or `kubectl` commands to troubleshoot any deployment issues.

---

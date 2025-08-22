- vProfile CI/CD with Jenkins

This project demonstrates a complete CI/CD pipeline for a Java-based microservice application using Jenkins, Maven, Docker, and Kubernetes.

It automates the workflow from code commit to deployment in a Kubernetes cluster, showcasing modern DevOps practices.

- Features

1- Automated pipeline defined in Jenkinsfile

2- Java build and test with Maven

3- Containerization with Docker

4- Image publishing to Docker Hub (or another registry)

5- Kubernetes manifests for deployment and service exposure

6- Rolling updates for zero-downtime deployments


- Repository Structure:

Jenkinsfile            # Defines CI/CD pipeline stages

Dockerfile             # Instructions for building the application container image

pom.xml                # Maven build configuration for the Java application

src/                   # Java application source code

k8s/                   # Kubernetes deployment manifests

- Pipeline Stages

1- Source Code Checkout – Jenkins pulls latest code from GitHub.

2- Build & Test – Maven compiles the code, runs unit tests, and packages the artifact.

3- Docker Build – Application container image built via Dockerfile.

4- Push to Registry – Docker image tagged and pushed to registry.

5- Kubernetes Deployment – Manifests applied to cluster with rolling update.

6- Pods Running – Updated application available in Kubernetes.

- Tools & Technologies

1- CI/CD: Jenkins

2- Build Tool: Maven

3- Containerization: Docker

4- Orchestration: Kubernetes

5- Registry: Docker Hub (configurable)

6- Source Control: GitHub

# DevOps Challenge 1

  

This is a level 1 challenge for candidates who want to join our DevOps team.

  

It is designed to test your level of familiarity with development and operations tools and concepts.

  

## Task

  

Create a simple microservice in **any** programming language of your choice, as follows:

  

- The application should be a web server that returns a JSON response, when its `/` URL path is accessed:

  

```json

{

"timestamp":  "<current date and time>",

"hostname":  "<Name of the host (IP also accepted)>",

"engine":  "<Name and/or version of the engine running>",

"visitor_ip":  "<the IP address of the visitor>"

}

```

  

- Create a Dockerfile for this microservice and publish the image to Docker Hub. Your application must be configured to run as a *non-root user* in the container.

  

- Create a Kubernetes manifest in YAML format, containing a Deployment and a Service, to deploy your microservice on Kubernetes. Your Deployment must use your public Docker image.

  

- Publish your code, Dockerfile, and Kubernetes manifests to a public Git repository in a platform of your choice (e.g. GitHub, GitLab, Bitbucket, etc.), so that it can be cloned and tested by the team.

  

## Important

  

Your task will be considered successful if a colleague is able to deploy your manifest to a running Kubernetes cluster and use your microservice correctly.

  

- Code quality and style: your code must be easy for others to read, and properly documented when relevant.

  

- Container best practices: your container image should be as small as possible, without unnecessary bloat.

  

# Commands in `makefile`

## Build the container

    make build

  ## Build an run the container

    make up
    curl http://localhost:9007
    {
      "engine": "flask",
      "hostname": "0e48e689d7f3",
      "timestamp": 1642632344.517643,
      "visitor_ip": "172.17.0.1"
    }

## Stop the running container

    make stop


## Authenticating to the Container registry

https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-to-the-container-registry
```shell
echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin
 > Login Succeeded
```

## Build a container and publish to ghcr.

### This build and publish to in multiples platforms like:

 1. linux/amd64
 2. linux/arm/v7
 3. linux/arm64 

```shell
make publish
```

> **ProTip:** You can add more to platforms section in `makefile` .
  ### Image can be pulled after : 

    docker pull ghcr.io/rafilkmp3/devops-challenge-level-1/my-super-app:0.0.1
    

  https://github.com/rafilkmp3/DevOps-Challenge-Level-1/pkgs/container/devops-challenge-level-1%2Fmy-super-app

###  The Github workflow of this repository is set to build and publish for every push to `main`  branch

## Build the container with different config and deploy file

    make dpl=another_deploy.env build

# Assignment 1 — CI/CD Pipeline with GitHub Actions and Docker Hub

## Objective

The objective of this assignment is to create a basic CI/CD pipeline that automatically builds a Docker image and pushes it to Docker Hub whenever code is pushed to the `main` branch of the GitHub repository.

The technologies used are:

* Python and Flask for the example application
* Docker for containerising the application
* GitHub for source control
* GitHub Actions for CI/CD automation
* Docker Hub as the container image registry

The final automated process is:

1. Application code is pushed to GitHub.
2. GitHub Actions detects the push to `main`.
3. GitHub provides an Ubuntu runner for the workflow.
4. The repository is checked out onto the runner.
5. The runner authenticates with Docker Hub.
6. Docker builds the application image.
7. The image is pushed to Docker Hub.
8. The image can then be pulled and run on another machine.

---

# 1. Project Structure

The application files for the assignment are stored under:

```text
CI-CD/Assignment-1/
```

The files are:

```text
Assignment-1/
├── app.py
├── Dockerfile
└── requirements.txt
```

The GitHub Actions workflow must be stored at the root of the Git repository under:

```text
.github/workflows/
```

Therefore, the overall repository contains:

```text
.github/workflows/assignment-1-docker.yml
CI-CD/Assignment-1/app.py
CI-CD/Assignment-1/Dockerfile
CI-CD/Assignment-1/requirements.txt
```

GitHub requires workflow files to be stored in `.github/workflows/` for GitHub Actions to detect them.

---

# 2. Flask Application

The application is a small Python Flask web application.

`app.py`:

```python
from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "CI/CD Pipeline Working!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

## Importing Flask

```python
from flask import Flask
```

Flask is a Python web framework.

It is not included with Python by default, so it must be installed as an additional dependency.

## Creating the Application

```python
app = Flask(__name__)
```

This creates the Flask application.

The `app` variable represents the web application that Flask will run.

## Creating a Route

```python
@app.route("/")
```

This defines what should happen when somebody accesses the root `/` URL of the application.

The following function is executed:

```python
def home():
    return "CI/CD Pipeline Working!"
```

The browser therefore receives:

```text
CI/CD Pipeline Working!
```

## Starting Flask

```python
app.run(host="0.0.0.0", port=5000)
```

The application listens on TCP port `5000`.

Using:

```text
0.0.0.0
```

allows Flask to listen on all available network interfaces. This is important when the application is running inside a Docker container because connections need to reach Flask from outside the container.

---

# 3. Python Dependencies

The application uses a `requirements.txt` file:

```text
flask
```

The application contains:

```python
from flask import Flask
```

However, Flask is not part of the Python standard library.

Therefore, Flask must be installed before the application can run.

`requirements.txt` records the Python packages required by the application.

They can be installed with:

```bash
pip install -r requirements.txt
```

In a production application, dependency versions would normally be pinned to make builds more predictable, for example:

```text
Flask==3.1.2
```

Pinning versions helps ensure that different builds use the same dependency versions.

---

# 4. Dockerfile

The Dockerfile defines how the application Docker image is created.

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
```

Each instruction has a specific purpose.

---

## FROM

```dockerfile
FROM python:3.12-slim
```

`FROM` defines the base image.

The application uses the official Python 3.12 slim image.

This provides an environment containing Python and the tools required to run the Python application.

The `slim` variant is smaller than the full Python image because it contains fewer unnecessary operating system packages.

---

## WORKDIR

```dockerfile
WORKDIR /app
```

This creates or selects `/app` as the working directory inside the container image.

Subsequent Dockerfile instructions operate relative to this directory.

This is similar in concept to changing directory with:

```bash
cd /app
```

The application files will therefore be placed inside `/app` in the container.

---

## COPY requirements.txt

```dockerfile
COPY requirements.txt .
```

This copies `requirements.txt` from the Docker build context into the current working directory inside the image.

Because the working directory is `/app`, the resulting location is:

```text
/app/requirements.txt
```

---

## RUN

```dockerfile
RUN pip install --no-cache-dir -r requirements.txt
```

`RUN` executes a command while the Docker image is being built.

This command tells `pip` to read `requirements.txt` and install the required Python dependencies.

For this application, Flask is installed.

The option:

```text
--no-cache-dir
```

prevents pip from retaining its download cache inside the image, which helps avoid unnecessary image size.

A key distinction is that `RUN` commands execute during:

```bash
docker build
```

They are not commands that wait until the container starts.

---

## COPY Application Files

```dockerfile
COPY . .
```

The first `.` refers to the Docker build context.

The second `.` refers to the current working directory inside the image.

Because the working directory is `/app`, the application files are copied into `/app`.

The Docker image now contains the application code required to run the service.

---

## Why `requirements.txt` Is Copied Separately

The Dockerfile first performs:

```dockerfile
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
```

and only afterwards:

```dockerfile
COPY . .
```

This can improve Docker's build caching.

Application source code may change frequently while dependencies change less frequently.

If `requirements.txt` has not changed, Docker may be able to reuse the previously created dependency layer instead of reinstalling all Python packages during every build.

---

## EXPOSE

```dockerfile
EXPOSE 5000
```

This documents that the application inside the container listens on port `5000`.

`EXPOSE` does not automatically make the port available on the host machine.

Port publishing is performed when the container is started with `docker run`.

---

## CMD

```dockerfile
CMD ["python", "app.py"]
```

`CMD` specifies the default command Docker executes when a container starts from the image.

This is equivalent to running:

```bash
python app.py
```

Python therefore executes `app.py`, which starts the Flask web server.

An important difference is:

```text
RUN = executed while building the Docker image

CMD = executed when starting a container from the image
```

---

# 5. Building the Image Locally

Before creating the CI/CD pipeline, the Docker image was tested locally.

The image was built using:

```bash
docker build -t assignment-1 .
```

## docker build

```text
docker build
```

tells Docker to build an image using the Dockerfile.

## -t

```text
-t assignment-1
```

assigns the image the name/tag `assignment-1`.

Because no explicit version tag was provided, Docker uses `latest` by default.

The local image can therefore be referred to as:

```text
assignment-1:latest
```

## Build Context

The final:

```text
.
```

means the current directory is used as the Docker build context.

The build context determines which files Docker can access during the build.

Because the command was executed from the `Assignment-1` directory, Docker could access:

```text
Dockerfile
app.py
requirements.txt
```

---

# 6. Docker Image vs Docker Container

A Docker image and a Docker container are different things.

A Docker image is the packaged application and its dependencies.

A Docker container is a running instance of that image.

The command:

```bash
docker build
```

creates an image.

The command:

```bash
docker run
```

creates and starts a container from an image.

Multiple containers can potentially be created from the same Docker image.

---

# 7. Running the Container Locally

The application was tested using:

```bash
docker run -p 5000:5000 assignment-1
```

This creates and starts a container from the `assignment-1` image.

When the container starts, Docker executes the Dockerfile's:

```dockerfile
CMD ["python", "app.py"]
```

Flask then starts listening on port `5000` inside the container.

---

## Port Mapping

The option:

```text
-p 5000:5000
```

publishes the container port.

The syntax is:

```text
-p HOST_PORT:CONTAINER_PORT
```

Therefore:

```text
-p 5000:5000
```

maps port `5000` on the local computer to port `5000` inside the container.

The application can then be accessed using:

```text
http://localhost:5000
```

It is also possible to use different host and container ports.

For example:

```bash
docker run -p 8080:5000 assignment-1
```

would still run Flask on port `5000` inside the container, but the application would be accessed from the host using port `8080`.

---

# 8. Why the Application Was Tested Locally First

Testing locally before creating the CI/CD pipeline reduces troubleshooting complexity.

The local test confirmed that:

* The Python application worked.
* Flask was installed correctly.
* The Dockerfile was valid.
* The Docker image could be built.
* The container could start.
* Port mapping worked.
* The application could be accessed from the browser.

This meant that any later problems with the CI/CD pipeline were more likely to relate to GitHub Actions, Docker Hub authentication, or pipeline configuration rather than the application itself.

---

# 9. Docker Hub

Docker Hub was used as the container registry for the assignment.

The Docker Hub repository was:

```text
humdaan7/assignment-1
```

A container registry provides a central location where Docker images can be stored and distributed.

GitHub stores the application's source code, while Docker Hub stores the built Docker image.

The image created by the pipeline is:

```text
humdaan7/assignment-1:latest
```

This can be broken down into:

```text
humdaan7       = Docker Hub namespace/username
assignment-1   = image repository
latest         = image tag
```

---

# 10. Why Docker Hub Is Required

An image built locally only exists on the machine where it was built.

Other machines cannot directly access that local image.

Publishing the image to Docker Hub allows other systems to retrieve it using:

```bash
docker pull humdaan7/assignment-1:latest
```

This could include:

* Another developer's machine
* A production server
* AWS
* Kubernetes
* A testing environment
* Another CI/CD system

Docker Hub therefore provides a central distribution point for the finished application image.

---

# 11. Docker Hub Access Token

GitHub Actions needs permission to push images into the Docker Hub repository.

A Docker Hub Personal Access Token was created for this purpose.

Using a dedicated token is preferable to placing the normal Docker Hub account password into an automated system.

The token can also be revoked separately if required.

---

# 12. GitHub Secrets

The Docker Hub credentials must not be written directly into the workflow.

For example, credentials should never be committed like this:

```yaml
username: myusername
password: my-secret-token
```

This could expose credentials through the Git repository.

Instead, two GitHub repository secrets were created:

```text
DOCKERHUB_USERNAME
DOCKERHUB_TOKEN
```

The workflow accesses them using:

```yaml
${{ secrets.DOCKERHUB_USERNAME }}
```

and:

```yaml
${{ secrets.DOCKERHUB_TOKEN }}
```

The workflow therefore refers to the secret names without storing the actual credentials in the source code.

---

# 13. GitHub Actions Workflow

The CI/CD workflow is stored at:

```text
.github/workflows/assignment-1-docker.yml
```

The workflow is:

```yaml
name: Build and Push Docker Image

on:
  push:
    branches:
      - main

jobs:
  build-and-push:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Build and push Docker image
        uses: docker/build-push-action@v6
        with:
          context: ./CI-CD/Assignment-1
          push: true
          tags: ${{ secrets.DOCKERHUB_USERNAME }}/assignment-1:latest
```

---

# 14. Workflow Name

```yaml
name: Build and Push Docker Image
```

This provides a human-readable name for the workflow.

The name appears in the GitHub Actions interface.

---

# 15. Workflow Trigger

```yaml
on:
  push:
    branches:
      - main
```

This defines when the workflow should execute.

The workflow runs whenever code is pushed to the `main` branch.

Therefore:

```bash
git push origin main
```

can automatically trigger the pipeline.

This is the event that connects normal Git development with the CI/CD automation.

---

# 16. Jobs

The workflow contains:

```yaml
jobs:
  build-and-push:
```

A GitHub Actions workflow can contain one or more jobs.

This assignment contains one job named:

```text
build-and-push
```

Its purpose is to build the Docker image and publish it to Docker Hub.

---

# 17. GitHub Actions Runner

The job contains:

```yaml
runs-on: ubuntu-latest
```

This tells GitHub Actions to execute the job using an Ubuntu runner.

The runner is the environment that performs the pipeline work.

The build therefore does not depend on the local development computer.

GitHub provides an environment that can execute the workflow independently.

---

# 18. Workflow Steps

The job contains multiple steps.

They execute in order:

1. Check out the repository.
2. Authenticate with Docker Hub.
3. Build and push the Docker image.

Each step prepares for the next step.

---

# 19. Checking Out the Repository

The first step is:

```yaml
- name: Checkout repository
  uses: actions/checkout@v4
```

The GitHub Actions runner initially needs access to the application's source code.

`actions/checkout@v4` checks out the Git repository onto the runner.

After this step, the runner has access to files such as:

```text
CI-CD/Assignment-1/app.py
CI-CD/Assignment-1/requirements.txt
CI-CD/Assignment-1/Dockerfile
```

Without this step, the later Docker build would not have the application source files available.

---

# 20. The `uses` Keyword

GitHub Actions supports reusable components known as Actions.

For example:

```yaml
uses: actions/checkout@v4
```

uses version 4 of the checkout Action.

The assignment also uses:

```yaml
docker/login-action@v3
```

and:

```yaml
docker/build-push-action@v6
```

These provide existing implementations of common CI/CD tasks rather than requiring all functionality to be written manually.

---

# 21. Logging into Docker Hub

The next step is:

```yaml
- name: Login to Docker Hub
  uses: docker/login-action@v3
  with:
    username: ${{ secrets.DOCKERHUB_USERNAME }}
    password: ${{ secrets.DOCKERHUB_TOKEN }}
```

The GitHub Actions runner must authenticate before Docker Hub will allow it to push an image into the repository.

`docker/login-action@v3` handles this authentication.

The username and token are retrieved from GitHub Secrets rather than being stored directly in the YAML file.

---

# 22. Building and Pushing the Image

The final main step is:

```yaml
- name: Build and push Docker image
  uses: docker/build-push-action@v6
```

This Action handles building and publishing the Docker image.

The configuration is:

```yaml
with:
  context: ./CI-CD/Assignment-1
  push: true
  tags: ${{ secrets.DOCKERHUB_USERNAME }}/assignment-1:latest
```

---

## Build Context

```yaml
context: ./CI-CD/Assignment-1
```

This tells the GitHub Action where the Docker build context is located.

The workflow runs from the repository, while the assignment's Dockerfile is inside:

```text
CI-CD/Assignment-1
```

The Action therefore needs to be explicitly pointed at that directory.

This is the automated equivalent of selecting the directory when running `docker build` locally.

---

## Push

```yaml
push: true
```

This tells the Action to push the image to the configured container registry after the build succeeds.

If the image were only built on the GitHub runner and not pushed, it would not remain available after the temporary runner finished.

Pushing it to Docker Hub provides persistent storage for the image.

---

## Image Tag

```yaml
tags: ${{ secrets.DOCKERHUB_USERNAME }}/assignment-1:latest
```

The Docker Hub username is retrieved from GitHub Secrets.

For this assignment, the resulting image is:

```text
humdaan7/assignment-1:latest
```

The image is then pushed to that Docker Hub repository.

---

# 23. What Happens When Code Is Pushed

When the following command is executed:

```bash
git push origin main
```

GitHub receives the new commit.

Because the workflow contains:

```yaml
on:
  push:
    branches:
      - main
```

GitHub Actions starts the workflow automatically.

The job then:

1. Starts an Ubuntu runner.
2. Checks out the repository.
3. Retrieves the Docker Hub credentials from GitHub Secrets.
4. Authenticates with Docker Hub.
5. Reads the Dockerfile from `CI-CD/Assignment-1`.
6. Builds the Docker image.
7. Tags the image as `humdaan7/assignment-1:latest`.
8. Pushes the image to Docker Hub.
9. Completes the workflow.

This means the developer does not need to manually build and push the Docker image after every code change.

---

# 24. Verifying the Published Image

After GitHub Actions completed successfully, Docker Hub showed the `latest` image tag.

The image was then downloaded using:

```bash
docker pull humdaan7/assignment-1:latest
```

The successful output confirmed that the image created by GitHub Actions was available from Docker Hub.

The downloaded image was then run using:

```bash
docker run --rm -p 5000:5000 humdaan7/assignment-1:latest
```

The application was accessible at:

```text
http://localhost:5000
```

and returned:

```text
CI/CD Pipeline Working!
```

This verified that the image produced and published by the CI/CD pipeline worked correctly.

---

# 25. Purpose of CI/CD in This Assignment

Without the GitHub Actions pipeline, the process would require manually performing tasks such as:

```bash
docker build
docker login
docker push
```

after making changes.

The pipeline automates these repetitive steps.

The developer can make changes, commit them and push them to `main`.

GitHub Actions then performs the build and publishing process consistently.

This reduces manual work and helps ensure that the same build process is followed each time.

---

# 26. Purpose of GitHub Actions

CI/CD is the automation approach or process.

GitHub Actions is the tool used in this assignment to implement that automation.

GitHub Actions:

* Detects pushes to `main`.
* Provides the runner.
* Downloads the repository.
* Authenticates with Docker Hub.
* Builds the Docker image.
* Pushes the image to Docker Hub.

Other CI/CD platforms could perform similar tasks, but GitHub Actions integrates directly with the GitHub repository used for this assignment.

---

# 27. Purpose of Docker Hub

Docker Hub is not responsible for building the source code in this assignment.

Its primary purpose is to act as the **container registry**.

GitHub contains the source code.

GitHub Actions performs the automated build.

Docker Hub stores and distributes the resulting Docker image.

The published image can then be pulled by another system using:

```bash
docker pull humdaan7/assignment-1:latest
```

---

# 28. CI and CD in This Assignment

The assignment demonstrates the CI/CD workflow, although its main focus is automated building and publishing rather than a full production deployment.

The CI portion includes automatically processing the application when code is pushed and producing a Docker image.

The pipeline then automatically publishes that image to Docker Hub.

A more advanced CD pipeline could continue by automatically deploying the published image to a platform such as:

* AWS ECS
* Kubernetes
* Azure
* A virtual machine
* Another production environment

This assignment stops after publishing and verifying the container image.

---

# 29. Key Commands

Build the image locally:

```bash
docker build -t assignment-1 .
```

Run the local image:

```bash
docker run -p 5000:5000 assignment-1
```

Push source code to GitHub:

```bash
git push origin main
```

Pull the CI/CD-built image from Docker Hub:

```bash
docker pull humdaan7/assignment-1:latest
```

Run the Docker Hub image:

```bash
docker run --rm -p 5000:5000 humdaan7/assignment-1:latest
```

---

# 30. Key Concepts to Remember

**Dockerfile**

Instructions describing how to build the application image.

**Docker Image**

A packaged version of the application, runtime and dependencies.

**Docker Container**

A running instance of a Docker image.

**Docker Hub**

The container registry used to store and distribute the finished image.

**GitHub**

Stores the source code and workflow configuration.

**GitHub Actions**

Runs the automated CI/CD workflow.

**GitHub Actions Runner**

The environment that executes the workflow jobs and steps.

**GitHub Secrets**

Securely stores credentials such as the Docker Hub username and access token.

**Build Context**

The directory containing the files Docker is allowed to use during an image build.

**`RUN`**

Executes a command while building the Docker image.

**`CMD`**

Defines the default command executed when a container starts.

**`EXPOSE`**

Documents the port used by the application inside the container.

**`-p HOST:CONTAINER`**

Maps a host port to a container port when starting a container.

**`docker build`**

Builds a Docker image.

**`docker run`**

Creates and starts a container from an image.

**`docker pull`**

Downloads an image from a container registry.

**CI/CD**

Automates the process of building, testing, publishing and potentially deploying software after changes are made.

---

# Summary

This assignment created a small Flask application and packaged it into a Docker image.

The application was first built and tested locally to confirm that the Docker configuration worked correctly.

A Docker Hub repository was then created to provide a central registry for the finished container image.

Docker Hub credentials were securely stored using GitHub Secrets.

A GitHub Actions workflow was created that runs whenever code is pushed to the `main` branch. The workflow starts an Ubuntu runner, checks out the repository, authenticates with Docker Hub, builds the Docker image from `CI-CD/Assignment-1`, and pushes the resulting image to Docker Hub as:

```text
humdaan7/assignment-1:latest
```

Finally, the image was pulled back from Docker Hub and run locally to verify that the image produced by the CI/CD pipeline worked correctly.

The main lesson from the assignment is that CI/CD removes repetitive manual build and publishing tasks. Instead of manually building and pushing a Docker image after every change, the developer pushes source code to GitHub and the pipeline performs the remaining steps automatically.

Add this at the very end of the README:

I am aware that GitHub Actions workflow files must normally be stored in the repository's root `.github/workflows/` directory for GitHub to detect and run them. After completing and testing this assignment, I moved `assignment-1-docker.yml` into the `Assignment-1` folder purely for organisation and to keep all files related to this assignment together.

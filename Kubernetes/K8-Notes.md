# Kubernetes Revision Notes

Concise notes covering core Kubernetes concepts.

------------------------------------------------------------------------

## 1. Pods, Nodes & Clusters

### Pod

-   The **smallest deployable unit** in Kubernetes.
-   Contains **one or more containers** that run together.
-   Containers in the same Pod share the **same network/IP** and can
    share storage.
-   Pods are **temporary (ephemeral)**: Kubernetes can replace them if
    they fail.
-   Usually, one Pod runs one main application container.

**Simple model:** Pod = wrapper around your application container(s).

### Node

-   A **machine** that runs Kubernetes Pods.
-   Can be a physical server or virtual machine.
-   A worker Node contains:
    -   **kubelet** --- makes sure Pods assigned to the Node are
        running.
    -   **container runtime** --- runs containers, e.g. containerd.
    -   **kube-proxy** --- helps implement Kubernetes Service
        networking.

**Simple model:** Node = worker machine where Pods run.

### Cluster

-   The **complete Kubernetes environment**.
-   Consists of:
    -   **Control Plane** --- manages the cluster.
    -   **Worker Nodes** --- run application Pods.

**Hierarchy:** Cluster → Nodes → Pods → Containers

------------------------------------------------------------------------

## 2. Control Plane

### What is the Control Plane?

The **management layer** of Kubernetes. It decides what should run,
where it should run, and continuously works to keep the cluster in the
desired state.

### API Server (`kube-apiserver`)

-   The **main entry point** to the Kubernetes control plane.
-   `kubectl`, users and Kubernetes components communicate through it.
-   Validates and processes API requests.

**Example:** `kubectl create deployment...` sends a request to the API
Server.

### etcd

-   Kubernetes' **key-value database**.
-   Stores the cluster's configuration and state.

**Example:** Stores information about Deployments, Pods, Nodes and
Secrets.

### Scheduler (`kube-scheduler`)

-   Finds Pods that do not yet have a Node.
-   Chooses the **best suitable Node** for each Pod based on resources
    and scheduling rules.

**Simple model:** Scheduler = decides *which Node* runs a Pod.

### Controller Manager (`kube-controller-manager`)

-   Runs controllers that continuously compare **desired state vs actual
    state**.
-   Takes action when they differ.

**Example:** Desired replicas = 3, but only 2 Pods exist → Kubernetes
creates another.

### Cloud Controller Manager

-   Connects Kubernetes with a supported **cloud provider's
    infrastructure**.
-   Handles cloud-specific resources such as load balancers, Nodes and
    routes where applicable.

**Example:** A `LoadBalancer` Service can cause the cloud provider to
provision an external load balancer.

------------------------------------------------------------------------

## 3. Services

### Service

-   Provides a **stable network endpoint** for a group of Pods.
-   Uses a **selector** to find matching Pods.
-   Needed because individual Pod IP addresses can change when Pods are
    replaced.

**Simple model:** Service = stable doorway to a changing group of Pods.

### ClusterIP

-   Default Service type.
-   Gives the Service an IP reachable **inside the cluster**.
-   Not directly accessible from outside the cluster.

**Use:** Internal communication between applications.

### NodePort

-   Opens a port on the Kubernetes Nodes, normally in the
    **30000--32767** range.
-   External traffic can reach the Service using: `NodeIP:NodePort`
-   The Service then forwards traffic to matching Pods.

**Example:** `192.168.1.10:30080` → Service → application Pods.

### LoadBalancer

-   Exposes a Service externally using an **external load balancer**,
    usually through a cloud provider.
-   The load balancer sends traffic to the Kubernetes Service and its
    Pods.

**Use:** Public applications in cloud environments.

### ExternalName

-   Maps a Kubernetes Service name to an **external DNS name**.
-   Does not proxy traffic to Pods.
-   Kubernetes DNS returns the configured external name.

**Use:** Let applications refer to an external service using a
Kubernetes-style Service name.

------------------------------------------------------------------------

## 4. Labels, Selectors & Namespaces

### Labels

-   **Key-value tags** attached to Kubernetes objects.
-   Used to identify and organise resources.

``` yaml
labels:
  app: ronin
  environment: production
```

### Selectors

-   Used to **find resources with matching labels**.
-   Services and Deployments commonly use selectors.

**Example:** A Service with selector `app: ronin` targets Pods labelled
`app: ronin`.

### Namespaces

-   Divide one cluster into **logical groups**.
-   Help organise and isolate resources.
-   Resource names generally only need to be unique within their
    Namespace.

**Examples:** `development`, `testing`, `production`.

------------------------------------------------------------------------

## 5. Deployments & ReplicaSets

### ReplicaSet

-   Ensures a specified **number of identical Pod replicas** are
    running.
-   Replaces Pods when they fail.

**Example:** Replicas = 3 → Kubernetes keeps 3 matching Pods running.

### Deployment

-   Higher-level controller used to manage application Pods.
-   Creates and manages **ReplicaSets**.
-   Supports:
    -   Scaling
    -   Rolling updates
    -   Rollbacks

**Relationship:** Deployment → ReplicaSet → Pods

**Example:** Change the container image in a Deployment → Kubernetes
performs a controlled rollout using ReplicaSets.

------------------------------------------------------------------------

## 6. ConfigMaps, Secrets, Volumes & PVCs

### ConfigMap

-   Stores **non-sensitive configuration** separately from the container
    image.
-   Can be provided to Pods as environment variables or files.

**Examples:** Application mode, hostname, feature setting.

### Secret

-   Stores **sensitive configuration** such as passwords, tokens and
    keys.
-   Can be provided to Pods as environment variables or mounted files.
-   Kubernetes Secrets are **base64-encoded by default, not
    automatically encrypted merely because they are Secrets**; cluster
    security and encryption-at-rest configuration still matter.

### Volume

-   Storage made available to containers inside a Pod.
-   Can allow data to survive a **container restart**.
-   Whether data survives the **Pod being deleted** depends on the
    volume type.

### PersistentVolume (PV)

-   A piece of persistent storage available to the cluster.
-   Has a lifecycle separate from an individual Pod.

### PersistentVolumeClaim (PVC)

-   A Pod/user's **request for persistent storage**.
-   Kubernetes binds the PVC to a suitable PV, or a StorageClass may
    dynamically provision one.

**Relationship:** Pod → PVC → PV → Storage

**Simple model:** PVC = "I need this much persistent storage."

------------------------------------------------------------------------

## 7. Probes

Probes allow Kubernetes to check the **health and availability** of
containers.

### Liveness Probe

-   Checks whether the container is **still healthy/alive**.
-   If it repeatedly fails, the kubelet **restarts the container**.

**Question answered:** "Is the application stuck or broken?"

### Readiness Probe

-   Checks whether the application is **ready to receive traffic**.
-   If it fails, the Pod is removed from matching Service endpoints
    until it becomes ready again.
-   The container is **not restarted just because readiness fails**.

**Question answered:** "Should users/Services send traffic here?"

### Startup Probe

-   Checks whether the application has **finished starting**.
-   While it is running successfully/awaiting success, liveness and
    readiness checks are held back as designed for startup.
-   Useful for applications that take a long time to start.
-   If the startup probe reaches its failure threshold, the container is
    restarted.

**Question answered:** "Has the application successfully started yet?"

### Quick Comparison

  -----------------------------------------------------------------------
  Probe                   Checks                  Main result when
                                                  failing
  ----------------------- ----------------------- -----------------------
  **Liveness**            Is it alive/healthy?    Container restarted
                                                  after failure threshold

  **Readiness**           Can it receive traffic? Removed from Service
                                                  traffic

  **Startup**             Has it started          Protects slow startup;
                          successfully?           restart after failure
                                                  threshold
  -----------------------------------------------------------------------

------------------------------------------------------------------------

## Core Revision Chain

**Cluster** → contains **Nodes** → Nodes run **Pods** → Pods run
**Containers**

**Control Plane** → manages the Cluster → Scheduler places Pods →
Controllers maintain desired state → etcd stores state → API Server is
the main interface

**Deployment** → manages **ReplicaSets** → ReplicaSets maintain **Pods**

**Service** → uses **labels/selectors** → provides stable access to Pods

**ConfigMap / Secret** → provides configuration

**PVC** → requests persistent storage

**Probes** → check startup, readiness and health

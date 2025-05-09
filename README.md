* * * * *

Metrics App Deployment with Helm, ArgoCD, and KIND
=====================================================

Objective
------------
Please refer to the assignment details in the following repository:

<https://github.com/cloudraftio/sre-assignment>

* * * * *

Repository Structure
------------------------
```
cloudraftio-assignment/
├── bootstrap.sh                   # Script to set up KIND cluster, ArgoCD, and ingress
├── README.md                      # This documentation
├── response.txt                   # Captured results from curl test
├── metrics-app/                   # Helm chart for the application         
|   ├── Chart.yaml
|   ├── values.yaml
|   ├── templates/
|   |    ├── _helpers.tpl
|   |    ├── deployment.yaml
|   |    ├── service.yaml
|   |    ├── ingress.yaml
|   |    ├── serviceaccount.yaml
|   |    └── secret.yaml
├── argocd/
│   └── app.yaml                   # ArgoCD Application manifest
├── scripts/
│   └── timing.sh            # Script to hit the /counter endpoint and record timing
└── docs/
    ├── observations.md            # Behavior analysis and debugging documentation
    └── screenshots/               # Evidence (screenshots, logs, etc.)
```
* * * * *

Deployment Steps
-------------------

### 1\. Clone the Repository

```
git clone https://github.com/saipavan9/cloudraftio-assignment.git
cd cloudraftio-assignment
```

### 2\. Set Up KIND and ArgoCD

```
chmod +x bootstrap.sh
./bootstrap.sh
```

This:

-   Creates a KIND cluster
-   Installs ArgoCD
-   Deploys K8s Metrics server 
-   Deploys Ingress Nginx
-   Deploys the metrics app via ArgoCD
-   Provides instructions on how to expose the ArgoCD UI and access it


### 3\. Ingress Access

Make sure the following is added to your `/etc/hosts` file:

```
sudo -- sh -c "echo '127.0.0.1 local.metrics-app.io' >> /etc/hosts"
```

Then access the app via:

```
curl http://local.metrics-app.io/counter
```

* * * * *

🔍 Testing the App
------------------

Run the provided test script:

```
./scripts/test.sh
```

This performs multiple `curl` requests to `/counter`, logging:

-   HTTP status
-   Response time
-   Output content

Results are stored in `response.txt`.

* * * * *
Observations & Debugging
---------------------------
See [`docs/observations.md`](docs/observations.md) for:

-   `/counter` behavior
-   Response latency
-   Resource usage spikes
-   Root cause analysis

* * * * *

Related screenshots and logs are available in `docs/screenshots/`

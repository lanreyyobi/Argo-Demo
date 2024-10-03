**Istio service mesh*

**Step 1a: Installation of Istio CLI**
```shell
curl -L https://istio.io/downloadIstio | sh -
export PATH="\$PATH:\$PWD/istio-1.7.3/bin"
```

**Step 1b: Installation of Istion in the cluster**
```shell
istioctl install --set profile=default -y
```

**Step 2: Verify that Istio is successfully installed**
```shell
kubectl get svc -n istio-system
kubectl get pods -n istio-system
```

**Step 3: Deploy a sample application**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world
spec:
  replicas: 3
  selector:
    matchLabels:
      app: hello-world
  template:
    metadata:
      labels:
        app: hello-world
    spec:
      containers:
      - name: hello-world
        image: 'k8s.gcr.io/echoserver:1.4'
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: hello-world
spec:
  ports:
  - port: 80
    targetPort: 8080
  selector:
    app: hello-world
```

**Step4: Apply configuration**
```shell
kubectl apply -f hello-world.yaml
```

**Step 5: Enable Istio injection**

- To let Istio manage your services, injection of Istio sidecars in your service pods is necessary.
- Label your namespace to automatically inject them with the following command
```shell
kubectl label namespace default istio-injection=enabled
```
When you create new pods, they will now have the Istio sidecar injected.

**Step 6: Accessing your services**
- Istio has installed an ingress gateway in your cluster. You can use it to access your services. 
- For this tutorial, we’ll create an Istio Gateway and VirtualService to route external traffic to our service.

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: hello-world-gateway
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      number: 80      
      name: http   
      protocol: HTTP
    hosts:
    - "*"
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: hello-world
spec:
  hosts:
  - "*"
  gateways:
  - hello-world-gateway
  http:
  - match:
    - uri:
        prefix: /
    route:
    - destination:
        host: hello-world
        port:
          number: 80
```

**Step 7: Observability with Istio**
Enable kiali dashboard
```shell
istioctl dashboard kiali
istioctl install --set addonComponents.grafana.enabled=true
```

**Step 8: Advanced traffic management**
- Istio allows you to manipulate the traffic flow between services.
```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: hello-world
spec:
  hosts:
    - "hello-world"
  http:
    - route:
        - destination:
            host: hello-world-v1
          weight: 80
        - destination:
            host: hello-world-v2
          weight: 20
```
- This configuration will send 80% of the traffic to version 1 of the hello-world service and 20% to version 2.

**Step 9: Clean up**

If you need to remove Istio from your cluster, you can use the following command:
```shell
istioctl manifest generate --set profile=default | kubectl delete --ignore-not-found=true -f -
kubectl label namespace default istio-injection-
```
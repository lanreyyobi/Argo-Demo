#!/bin/bash

set -x

cd manifests
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.17.1 TARGET_ARCH=x86_64 sh -
sleep 10
export PATH=$PWD/bin:$PATH

kubectl create namespace istio-system
helm install -n istio-system istio-base \
    istio-1.17.1/manifests/charts/base
sleep 10
helm install -n istio-system istiod \
    istio-1.17.1/manifests/charts/istio-control/istio-discovery \
    --set global.hub="docker.io/istio" --set global.tag="1.17.1"
sleep 10
helm install -n istio-system istio-ingress \
    istio-1.17.1/manifests/charts/gateways/istio-ingress \
    --set global.hub="docker.io/istio" --set global.tag="1.17.1" \
    --set gateways.istio-ingressgateway.serviceAnnotations."service\.beta\.kubernetes\.io/aws-load-balancer-proxy-protocol"="*" \
    --set gateways.istio-ingressgateway.serviceAnnotations."service\.beta\.kubernetes\.io/aws-load-balancer-connection-idle-timeout"="60" \
    --set gateways.istio-ingressgateway.serviceAnnotations."service\.beta\.kubernetes\.io/aws-load-balancer-cross-zone-load-balancing-enabled"="true" \
    --set gateways.istio-ingressgateway.serviceAnnotations."service\.beta\.kubernetes\.io/aws-load-balancer-type"="nlb"
sleep 10
kubectl label namespace default istio-injection=enabled
kubectl get namespaces --show-labels
kubectl create -f istio-1.17.1/samples/addons/kiali.yaml
sleep 10
kubectl get pods -n istio-system
kubectl apply -f manifests/microservice.yaml
sleep 10
istioctl dashboard kiali
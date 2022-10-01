#!/bin/bash

echo running a2_setup.sh
# To create cluster
kind create cluster --name kind-1 --config ./kind/cluster-config.yaml

# load A1 Docker image to kind, not needed when pulling container images from dockerhub
#kind load docker-image otot-a1_nodeserver --name kind-1

# Create deploy and wait for pods to be in ready status
echo Creating Deployment
kubectl apply -f ./manifests/backend_deployment.yaml --context kind-kind-1
kubectl wait --for=condition=ready pod -l app=backend --timeout=180s --context kind-kind-1
echo Deployment pods ready

echo Creating service
kubectl apply -f ./manifests/backend_service.yaml --context kind-kind-1
echo Done creating service

echo Creating ingress-nginx controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml --context kind-kind-1
kubectl wait --namespace=ingress-nginx --for=condition=ready -l app.kubernetes.io/component=controller pod --timeout=180s
echo ingress-nginx controller pods ready

echo Creating ingress
kubectl apply -f ./manifests/backend_ingress.yaml --context kind-kind-1

echo Done creating ingress

sleep 30s

# useful debugging commands:
# kubectl port-forward <pod id> <host port>:<port exposed in container>
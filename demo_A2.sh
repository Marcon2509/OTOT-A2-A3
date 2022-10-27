# ======================
echo "Task A2 demo"

echo $line
# ======================
# ======================
echo "Initialzing"

echo $line
# ======================

echo "Create cluster"
kind create cluster --name kind-1 --config k8s/kind/cluster-config.yaml

echo $line

echo "Apply backend-deployment"
kubectl apply -f k8s/manifests/backend-deployment.yaml

echo $line

echo "Label ingress-ready"
kubectl label node kind-1-control-plane ingress-ready=true
kubectl label node kind-1-worker ingress-ready=true
kubectl label node kind-1-worker2 ingress-ready=true
kubectl label node kind-1-worker3 ingress-ready=true

echo $line

echo "Apply ingress controller"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

echo $line

echo "Apply backend-service"
kubectl apply -f k8s/manifests/backend-service.yaml

echo $line

echo "Apply backend-ingress"
kubectl apply -f k8s/manifests/backend-ingress.yaml

echo $line

# ======================
echo "Verification section:"

echo $line
# ======================

echo "Check docker"
docker ps

echo $line

echo "Inspect node containers"
kubectl get nodes

echo $line

echo "Check cluster info"
kubectl cluster-info

echo $line

echo "Wait for backend deployment"
kubectl rollout status deployment/backend

echo $line

echo "Verify Deployment"
kubectl get deployment.apps/backend

echo $line

echo "Verify individual containers"
kubectl get po -l app=backend --watch

echo $line

echo "Verify labels of ingress-ready"
kubectl get nodes -L ingress-ready --watch

echo $line

echo "Wait for Ingress Deployment"
kubectl -n ingress-nginx rollout status deploy --watch

echo $line

echo "Check progress ingress controller"
kubectl -n ingress-nginx get deploy

echo $line

echo "Verify service"
kubectl get svc -l app=backend

echo $line

echo "Describe backend-svc"
kubectl describe svc backend-svc

echo $line

kubectl port-forward service/backend-svc 8080:8080

echo $line

echo "Verify ingress"
kubectl get ingress -l app=backend

echo $line

echo "Check location for ingress"
kubectl describe ingress backend-ingress

read -p "Press enter to exit"
echo Deleting all resources for a2

kubectl delete ingress backend-ingress

kubectl delete deploy -n ingress-nginx ingress-nginx-controller

kubectl delete service backend-service

kubectl delete deploy backend

kind delete cluster -n kind-1

echo Done deleting all resources for a2
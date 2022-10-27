# ======================
echo "Task A3 demo"

echo $line
# ======================
# ======================
echo "Initialzing"

echo $line
# ======================

echo "Instal metrics-servers"
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

echo $line

echo "Edit the TLF Deployment manifest and add a flag `--kubelet-insecure-tls` to `deployment.spec.containers[].args[]`. copy paste from metrics-server-cop-paste.yaml"
kubectl -nkube-system edit deploy/metrics-server

echo $line

echo "Reset the TLF Deloyment"
kubectl -nkube-system rollout restart deploy/metrics-server

echo $line

echo "Apply Horizontal Pod Autoscaler"
kubectl apply -f k8s/manifests/backend-hpa.yaml

echo $line

echo "Apply backend-zone-aware"
kubectl apply -f k8s/manifests/backend-zone-aware.yaml

echo $line

# ======================
echo "Verification section:"

echo $line
# ======================

echo "Verify HPA"
kubectl get po
kubectl describe HPA

echo $line

echo "View nodes"
kubectl get nodes -L topology.kubernetes.io/zone

echo $line

echo "Verify backend-zone-aware"
kubectl get po -lapp=backend-zone-aware -owide --sort-by='.spec.nodeName'

read -p "Press enter to exit"
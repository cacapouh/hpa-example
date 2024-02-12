rm -rf result/*
minikube delete --all  # Minikubeの場合
minikube start --memory=4096  # Minikubeの場合
minikube addons enable metrics-server  # Minikubeの場合

docker build . -t simple-app:latest
minikube image load simple-app:latest  # Minikubeの場合

kubectl apply -f simple-app.yaml
kubectl get pods > result/pods1.txt

kubectl autoscale deployment simple-app --cpu-percent=50 --min=1 --max=10
kubectl get hpa > result/hpa1.txt
kubectl get hpa -o yaml > result/hpa.yaml

watch 'kubectl get hpa | tee -a result/hpa2.txt'
watch 'kubectl get pods | tee -a result/pods2.txt'
watch 'echo "$(date), $(kubectl get pods --no-headers | grep simple-app | wc -l)" | tee -a result/pods-count.csv'

kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://simple-app; done"

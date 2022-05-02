#!/bin/bash

USERNAME=krisclarkdev
PRIMARY_AGENT=192.168.6.2
WORKER_AGENTS=(192.168.6.3 192.168.6.4 192.168.6.5 192.168.6.6 192.168.6.7 192.168.6.8 192.168.6.9 192.168.6.10 192.168.6.11 192.168.6.12)

# Install primary agent
echo "Installing primary agent"
ssh $USERNAME@$PRIMARY_AGENT "curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644"

echo "Waiting 10 seconds for everything to settle"
sleep 10
echo "Done"

echo "Setting config on primary agent"
ssh $USERNAME@$PRIMARY_AGENT "kubectl get nodes"
ssh $USERNAME@$PRIMARY_AGENT "sudo cp /etc/rancher/k3s/k3s.yaml /home/$USERNAME/.kube/config && sudo chown $USERNAME:$USERNAME ~/.kube/config"
mkdir ~/.kube
scp $USERNAME@$PRIMARY_AGENT:/home/$USERNAME/.kube/config ~/.kube/
sed -i "" "s/127.0.0.1/$PRIMARY_AGENT/g" $HOME/.kube/config
echo "Done"

echo "Getting config for primary agent"
scp $USERNAME:$PRIMARY_AGENT:~/.kube/config ~/.kube/config
echo "Done"

echo "Getting primary agent token"
TOKEN=$(ssh $USERNAME@$PRIMARY_AGENT "sudo cat /var/lib/rancher/k3s/server/token")
echo "Done"

for i in "${WORKER_AGENTS[@]}"
do
   echo "Installing agent on $i"
   ssh $USERNAME@$i "curl -sfL https://get.k3s.io | K3S_URL=https://$PRIMARY_AGENT:6443 K3S_TOKEN=$TOKEN sh -"
   echo "Done"
done


# Automated install of metallb - assumes you have metallb-config.yaml in the same directory of this script
echo "Running automated post install deployments"
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/namespace.yaml
kubectl create -f ./metallb-config.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/metallb.yaml

# Do your automated installs here, example shown is Tanzu Observability
helm repo add wavefront https://wavefronthq.github.io/helm/ && helm repo update
kubectl create namespace wavefront && helm install wavefront wavefront/wavefront --set wavefront.url=https://try.wavefront.com --set wavefront.token=TOKEN --set clusterName="k3s" --namespace wavefront
echo "Done"

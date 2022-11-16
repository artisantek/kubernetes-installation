# KUBERNETES INSTALLATION STEPS

## STEP 1: MASTER NODE INSTALLATION

- Create EC2 Instance from UBUNTU AMI with type t2.medium (2 core CPU and 4GB Ram)
- Github URL: https://github.com/adhig93/k8sinstall [use installk8s-1.23.8.sh - stable]

### COMMANDS:
```
git clone https://github.com/adhig93/k8sinstall.git
cd k8sinstall
sudo sh installk8s-1.23.8.sh
```

## STEP 2: Kubernetes node template is now ready create an AMI from this instance to create worker nodes

### To create an AMI from an instance
1. Right-click on the instance you want to use as the basis for your AMI or Click-on Actions button.
2. Action --> Image --> Create Image

Once the Ami is available (usually it takes 2-8 minutes to get ready), create instances with t2.micro to
create worker nodes.

## STEP 3: Login back to Master instance created in STEP 1

### Initializing Master Server [root user]

```
sudo su --> To goto root user
kubeadm init --> To initialize Master server
```
>Note: Copy the command along with token generated and keep it in a separate file, we need to run this command on worker nodes

### Configuring Kube [ubuntu user]

```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### Installing a CNI network on master node [ubuntu user]
```
sudo sysctl net.bridge.bridge-nf-call-iptables=1
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
kubectl get nodes
```

## STEP 4: Initialize WORKER NODES [ssh to worker nodes created from STEP 2]

```
sudo su --> To goto root user
kubeadm join <TOKEN> [Command from STEP 3] --> To connect worker node to Master
```

## STEP 5: Login back to Master instance created in STEP 1

```
kubectl get nodes --> To list all the nodes on the cluster
```

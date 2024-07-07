#!/bin/bash

echo -e "\n################################################################"
echo "#                                                              #"
echo "#                     ***Artisan Tek***                        #"
echo "#                  Kubernetes Installation                     #"
echo "#                                                              #"
echo -e "################################################################\n"


# Step 1: Update and upgrade system packages
echo "     Step 1: Updating and upgrading system packages..."
sudo apt update >/dev/null 2>&1
sudo apt upgrade -y >/dev/null 2>&1
echo "            -> Done"

# Step 2: Disable swap and update fstab
echo "     Step 2: Disabling swap and updating fstab..."
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
echo "            -> Done"

# Step 3: Load necessary kernel modules
echo "     Step 3: Loading kernel modules..."
echo -e "overlay\nbr_netfilter" | sudo tee /etc/modules-load.d/containerd.conf >/dev/null
sudo modprobe overlay
sudo modprobe br_netfilter
echo "            -> Done"

# Step 4: Set system configurations for Kubernetes
echo "     Step 4: Setting system configurations for Kubernetes..."
echo -e "net.bridge.bridge-nf-call-ip6tables = 1\nnet.bridge.bridge-nf-call-iptables = 1\nnet.ipv4.ip_forward = 1" | sudo tee /etc/sysctl.d/kubernetes.conf >/dev/null
sudo sysctl --system >/dev/null 2>&1
echo "            -> Done"

# Step 5: Install Docker and Containerd
echo "     Step 5: Installing Docker and Containerd..."
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates >/dev/null 2>&1
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" >/dev/null 2>&1
sudo apt update >/dev/null 2>&1
sudo apt install -y containerd.io >/dev/null 2>&1
echo "            -> Done"

# Configure containerd
echo "     Step 6: Configuring containerd..."
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
sudo systemctl restart containerd >/dev/null 2>&1
sudo systemctl enable containerd >/dev/null 2>&1
echo "            -> Done"

# Step 7: Install Kubernetes components
echo "     Step 7: Installing Kubernetes components..."
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmour -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list >/dev/null
sudo apt update >/dev/null 2>&1
sudo apt install -y kubeadm kubelet kubectl >/dev/null 2>&1
echo "            -> Done"

echo -e "\n################################################################ \n"
echo "  Kubernetes node template is now created "
echo "  Create AMI form this node to create worker nodes"
echo "  Note: This node will be your master node "
echo -e "\n################################################################ \n"
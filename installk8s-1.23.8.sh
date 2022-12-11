#/bin/bash

echo "\n################################################################"
echo "#                                                              #"
echo "#                     ***Artisan Tek***                        #"
echo "#                  Kubernetes Installation                     #"
echo "#                                                              #"
echo "################################################################"

echo "     Running script with $(whoami)"

echo "     STEP 1: Disabling Swap"
        # First diasbale swap
        sudo swapoff -a 1>/dev/null
        # And then to disable swap on startup in /etc/fstab
        sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab 1>/dev/null
echo "            -> Done"

echo "     STEP 2: Installing apt-transport-https"
        apt-get install -y apt-transport-https 1>/dev/null
        curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add > /dev/null 2>&1
        echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list
echo "            -> Done"

echo "     STEP 3: Updating apt"
        apt-get update > /dev/null 2>&1
echo "            -> Updated ...."

echo "     STEP 4: Installing Docker"
        curl -fsSL https://get.docker.com -o get-docker.sh 
        sh get-docker.sh > /dev/null 2>&1
echo "            -> Done"

echo "     STEP 5: C-Group Error Fix and Restarting Components"
        echo "{ \n \"exec-opts\": [\"native.cgroupdriver=systemd\"]\n}" > /etc/docker/daemon.json
        systemctl daemon-reload 1>/dev/null
        systemctl restart docker 1>/dev/null
echo "            -> Done"

echo "     STEP 6: Installing kubenetes master components"
        echo "            -> Installing kubelet"
                apt-get install -y kubelet=1.23.8-00 1>/dev/null
        echo "            -> Installing kubeadm"
                apt-get install -y kubeadm=1.23.8-00 1>/dev/null
        echo "            -> Installing kubectl"
                apt-get install -y kubectl=1.23.8-00 1>/dev/null
        echo "            -> Installing kubernetes-cni"
                apt-get install -y kubernetes-cni 1>/dev/null
     

echo "\n################################################################ \n"
echo "  Kubernetes node template is now created "
echo "  Create AMI form this node to create worker nodes"
echo "  Note: This node will be your master node "
echo "\n################################################################ \n"
exit

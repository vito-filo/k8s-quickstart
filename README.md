# k8s-quickstart
This repository contains scripts to automate k8s installation and set up a cluster with kubeadm.


## How to install
Clone the repository in all nodes (Master and workers)
```bash
# git clone https://github.com/vito-filo/k8s-quickstart.git
```
### On the Master node
Change file permission and execute the master_init script.
```bash
# cd k8s-quickstart
# chmod +x master_init.sh
# ./master_init.sh
```

At the end of the process this message will be printed
```bash
Then you can join any number of worker nodes by running the following on each as root:
kubeadm join 172.45.32.70:6443 --token i8d7xz.w6bhac21aw4ei6nu \
    --discovery-token-ca-cert-hash sha256:c76de3b9ddf430ea65f702d0d4cs940frt47f998abdc57bc2bdc938df610e207
```
copy the cluster ip, connection token, and ca-cert in order to join the cluster from the worker node.

### On the worker node
Change file permission and execute the worker_init script.
```bash
# cd k8s-quickstart
# chmod +x worker_init.sh
# ./worker_init.sh -i 172.45.32.70:6443 -t i8d7xz.w6bhac21aw4ei6nu -ca sha256:c76de3b9ddf430ea65f702d0d4cs940frt47f998abdc57bc2bdc938df610e207
```

### Check the installation
On teh worker node run:
```bash
# kubectl get nodes
NAME      STATUS    ROLES     AGE       VERSION
kube-01   Ready     master    8m        v1.9.3
kube-02   Ready     <none>    6m        v1.9.3
kube-03   Ready     <none>    6m        v1.9.3
```
you should see a list wih the master an all nodes in the cluster.

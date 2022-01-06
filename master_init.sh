RED='\033[0;31m'
NC='\033[0m' # No Color

# Setup configuration
printf "${RED}Step 1/4: Setup installation ${NC}\n"
apt-get update
apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

# Install kubelet kubeadm kubectl docker.io
printf "${RED}Step 2/4: install k8s tools and Docker ${NC}\n"
apt-get update
apt-get install -y kubelet=1.15.4-00 kubeadm=1.15.4-00 kubectl=1.15.4-00 docker.io

printf "${RED}Step 3/4: Create cluster ${NC}\n"
kubeadm init
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

printf "${RED}Step 4/4: Install Weave Net Add-On ${NC}\n"
curl -o weave.yaml https://cloud.weave.works/k8s/v1.8/net.yaml
cat weave.yaml
kubectl apply -f weave.yaml

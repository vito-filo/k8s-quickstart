RED='\033[0;31m'
NC='\033[0m' # No Color

for arg in "$@"
do
    case $arg in
        -i | --ip)
            ip=$2
            shift
            shift
        ;;
        -h|--help)
            cat help_master.txt
            exit 1
        ;;
        -*|--*)
            echo "Unknown argument $1"
            cat help_master.txt
            exit 1
        ;;
    esac
done
if [[ $ip != "" ]]
then
    printf "${RED}Step 1/3: install Docker ${NC}\n"
    sudo apt-get update && sudo apt-get install -qy docker.io
    printf "${RED}Step 2/3: install Kubernetes tools ${NC}\n"
    sudo apt-get update && sudo apt-get install -y apt-transport-https && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - OK
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list && sudo apt-get update
    sudo apt-get update && sudo apt-get install -yq kubelet kubeadm kubernetes-cni
    sudo apt-mark hold kubelet kubeadm kubectl
    printf "${RED}Step 3/3: Join the cluster ${NC}\n"
    sudo kubeadm init --apiserver-advertise-address=$ip
else
    echo "Invalid parameters";
    cat help_master.txt
fi

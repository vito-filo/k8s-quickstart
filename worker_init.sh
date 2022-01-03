RED='\033[0;31m'
NC='\033[0m' # No Color

for arg in "$@"
do
    case $arg in
        -i | --ip)
            cluster_ip=$2
            shift
            shift
        ;;
        -t | --token)
            token=$2
            shift
            shift
        ;;
        -ca | --ca-certificate)
            ca=$2
            shift
            shift
        ;;
        -h|--help)
            cat worker_help.txt
            exit 1
        ;;
        -*|--*)
            echo "Unknown argument $1"
            cat worker_help.txt
            exit 1
        ;;
    esac
done
if [[ $cluster_ip != "" && $token!="" &&  $ca!="" ]]
then
    printf "${RED}Step 1/3: install Docker ${NC}\n"
    sudo apt-get update && sudo apt-get install -qy docker.io
    sudo apt-get update && sudo apt-get install -y apt-transport-https
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    printf "${RED}Step 2/3: install Kubernetes tools ${NC}\n"
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list && sudo apt-get update
    sudo apt-get update && sudo apt-get install -yq kubelet kubeadm kubernetes-cni
    sudo apt-mark hold kubelet kubeadm kubectl
    printf "${RED}Step 3/3: Join the cluster ${NC}\n"
    kubeadm join $cluster_ip --token $token --discovery-token-ca-cert-hash $ca
else
    echo "Invalid parameters";
    cat worker_help.txt
fi

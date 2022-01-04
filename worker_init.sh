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
            cat help_worker.txt
            exit 1
        ;;
        -*|--*)
            echo "Unknown argument $1"
            cat help_worker.txt
            exit 1
        ;;
    esac
done
if [[ $ip != "" && $token!="" &&  $ca!="" ]]
then
    # Setup configuration
    printf "${RED}Step 1/3: Setup installation ${NC}\n"
    apt-get update && apt-get install -y apt-transport-https
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

    # Install kubelet kubeadm kubectl docker.io
    printf "${RED}Step 2/3: install k8s tools and Docker ${NC}\n"
    apt-get update
    apt-get install -y kubelet=1.15.4-00 kubeadm=1.15.4-00 kubectl=1.15.4-00 docker.io
    
    printf "${RED}Step 3/3: Join the cluster ${NC}\n"
    kubeadm join --token $token $ip --discovery-token-ca-cert-hash $ca
else
    echo "Invalid parameters";
    cat help_worker.txt
fi

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
        -dt | --discovery-token)
            discovery_token=$2
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
if [[ $ip != "" && $token!="" &&  $discovery_token!="" ]]
then
    sudo apt-get update && sudo apt-get install -qy docker.io
    sudo apt-get update && sudo apt-get install -y apt-transport-https && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - OK
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list && sudo apt-get update
    sudo apt-get update && sudo apt-get install -yq kubelet kubeadm kubernetes-cni
    sudo apt-mark hold kubelet kubeadm kubectl
    kubeadm join $ip --token $token --discovery-token-ca-cert-hash $discovery_token
else
    echo "Invalid parameters";
    cat worker_help.txt
fi

#!/usr/bin/env bash

cd `dirname $0`

curl -sL https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -sL https://nvidia.github.io/nvidia-docker/$(. /etc/os-release;echo $ID$VERSION_ID)/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

curl -sL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker-stable.list
sudo apt-get update
sudo apt-get install -y docker-ce nvidia-container-toolkit nvidia-container-runtime
sudo usermod -a -G docker $(awk -F: '$3==1000 {print $1}' /etc/passwd)
if [ -e /etc/docker/daemon.json ]; then
    echo '/etc/docker/daemon.json file existed, please add nvidia-container-runtime manually.'
else
    sudo tee /etc/docker/daemon.json << EOF
{
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
EOF
fi
sudo systemctl restart docker

sudo cp ./local/docker-compose /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

#!/bin/bash

ssh_pub_key_path="${HOME}/.ssh/${1:?}"

if [[ ! "${ssh_pub_key_path}" == *.pub ]]; then
    echo "[WARNING]: Provided key may not be public! Ending script execution"
    exit 1
fi

echo "[INFO]: Building git-server image..."
docker build -t git-server .

echo "[INFO]: Using ssh key ${ssh_pub_key_path} as authorized_keys"
echo "[INFO]: Creating git-server container..."
docker run -d \
    --name git-server \
    -p 2222:22 \
    -v "${ssh_pub_key_path}:/home/git/.ssh/authorized_keys:ro" \
    git-server

echo "[INFO]: Creating dummy repo demo.git"
docker exec -u git -it git-server git init --bare /home/git/repos/demo.git

echo "[INFO]: Cloning demo.git from local repo running in git-server container"
git clone ssh://git@localhost:2222/home/git/repos/demo.git


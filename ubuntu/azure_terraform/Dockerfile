FROM ubuntu:24.04

ARG USERNAME=ubuntu

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/home/${USERNAME}
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN apt update && apt install -y \
    python3 vim wget gnupg locales \
    software-properties-common wl-clipboard \
    apt-transport-https sudo xclip \
    ca-certificates curl lsb-release \
    build-essential python3-venv python3-pip \
    ripgrep fd-find unzip git && \
    rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/fdfind /usr/local/bin/fd

RUN pip3 install --no-cache-dir --break-system-packages pynvim

RUN locale-gen en_US.UTF-8

RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu && \
    chmod 0440 /etc/sudoers.d/ubuntu

RUN mkdir -p /etc/apt/keyrings && \
    curl -sLS https://packages.microsoft.com/keys/microsoft.asc | \
        gpg --dearmor > /etc/apt/keyrings/microsoft.gpg && \
    chmod go+r /etc/apt/keyrings/microsoft.gpg

RUN AZ_DIST=$(lsb_release -cs) && \
    cat <<EOF > /etc/apt/sources.list.d/azure-cli.sources
Types: deb
URIs: https://packages.microsoft.com/repos/azure-cli/
Suites: ${AZ_DIST}
Components: main
Architectures: $(dpkg --print-architecture)
Signed-by: /etc/apt/keyrings/microsoft.gpg
EOF

RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
        gpg --dearmor > /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list

RUN apt update && \
    apt install -y azure-cli terraform && \
    rm -rf /var/lib/apt/lists/*

RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz && \
    tar -C /opt -xzf nvim-linux-x86_64.tar.gz && \
    ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim && \
    rm nvim-linux-x86_64.tar.gz

USER ${USERNAME}
WORKDIR /home/${USERNAME}

RUN git clone https://github.com/LazyVim/starter ~/.config/nvim && \
    rm -rf ~/.config/nvim/.git

RUN mkdir -p ~/.config/nvim/lua/config && \
    printf 'vim.opt.mouse = ""\nvim.opt.clipboard = "unnamedplus"\n' \
    > ~/.config/nvim/lua/config/options.lua

RUN nvim --headless "+Lazy! sync" +qa

RUN git config --global alias.st status && \
    git config --global alias.ci commit

WORKDIR /workspace


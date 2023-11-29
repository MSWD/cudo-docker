FROM nvidia/cuda:11.5.2-cudnn8-devel-ubuntu20.04

# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

ENV DEBIAN_FRONTEND=noninteractive

RUN \
    apt-get update && \
    apt-get install -y wget dnsutils systemd systemd-sysv libpci3 libpci-dev libx11-dev \
                       libxext-dev libxxf86vm-dev libnuma-dev libnvidia-ml-dev less vim \
                       python3-pip iputils-ping && \
    python3 -m pip install nvitop

WORKDIR /tmp

ADD ./cudominer-install.sh .

RUN \
    ORG=athlonia-bogey bash /tmp/cudominer-install.sh --install-mode=headless --install-cli --update-channel=stable --quiet && \
    systemctl enable cudo-miner.service

ENV SOCKET_PATH=/var/lib/cudo-miner.sock
ENV REBOOT_IDLE_TIME=30
ENV STORE_PATH=/var/lib/cudo-miner/store
ENV REGISTRY_PATH=/var/lib/cudo-miner/registry
ENV BIN_PATH=/usr/local/cudo-miner/bin
ENV RUNTIME_PATH=/usr/local/cudo-miner/runtime

WORKDIR /usr/local/cudo-miner

VOLUME [ "/sys/fs/cgroup" ]

CMD ["/lib/systemd/systemd"]



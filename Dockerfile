FROM nvidia/cuda:10.0-base

RUN dpkg --add-architecture i386 && \
    apt update -y && \
    apt install -y \
    libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386 \
    build-essential git wget unzip sudo \
    libxrender1 libxtst6 libxi6 libfreetype6 libxft2 \
    qemu qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils libnotify4 libglu1 libqt5widgets5 openjdk-8-jdk xvfb \
    && \
    apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime

RUN DEBIAN_FRONTEND=noninteractive apt update -y && \
    apt install -y \
    git \
    imagemagick \
    curl \
    wget \
    gconf-service \
    lib32gcc1 \
    lib32stdc++6 \
    libasound2 \
    libc6 \
    libc6-i386 \
    libcairo2 \
    libcap2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libfreetype6 \
    libgcc1 \
    libgconf-2-4 \
    libgdk-pixbuf2.0-0 \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libglu1-mesa \
    libgtk2.0-0 \
    libnspr4 \
    libnss3 \
    libpango1.0-0 \
    libstdc++6 \
    libx11-6 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxtst6 \
    zlib1g \
    debconf \
    npm \
    xdg-utils \
    lsb-release \
    libpq5 \
    xvfb \
    python-yaml \
    python-pip \
    python-dev \
    build-essential \
    virtualenv \
    python \
    x11vnc \
    xvfb \
    sudo \
    fuse \
    blender \
    mesa-utils \
    && \
    apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN DEBIAN_FRONTEND=noninteractive apt update -y && \
    apt install -y \
    desktop-file-utils \
    zenity \
    && \
    apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG HOST_USER=goodnotes

ARG HOST_UID=1000

ARG HOST_GID=100

ENV HOST_USER=$HOST_USER

ENV HOST_UID=$HOST_UID

ENV HOST_GID=$HOST_GID

RUN useradd -g ${HOST_GID} -G sudo,video,audio -u ${HOST_UID} -m -s /bin/bash ${HOST_USER}

RUN echo "${HOST_USER}:${HOST_USER}" | chpasswd

ADD UnityHub.AppImage /home/UnityHub.AppImage

RUN chmod +x /home/UnityHub.AppImage

ADD android-studio.tar.gz /home/android-studio.tar.gz

RUN chown -R ${HOST_UID}:${HOST_GID} /home/android-studio.tar.gz

USER ${HOST_USER}

WORKDIR /home/${HOST_USER}

CMD /usr/bin/env bash

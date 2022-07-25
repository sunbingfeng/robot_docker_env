FROM stereolabs/zed:3.4-ros-devel-cuda11.0-ubuntu18.04

ARG UID=1000
ARG USER=bot
ARG USR_PWD=$USER

USER root

# Setup environment
RUN echo '199.232.28.133 raw.githubusercontent.com' >> /etc/hosts && curl https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

RUN rm /etc/apt/sources.list.d/cuda.list
RUN rm /etc/apt/sources.list.d/nvidia-ml.list
RUN apt-key del 7fa2af80
RUN apt-get update && apt-get install -y --no-install-recommends wget
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-keyring_1.0-1_all.deb
RUN dpkg -i cuda-keyring_1.0-1_all.deb

RUN apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV \
  LANG=en_US.UTF-8 \
  DEBIAN_FRONTEND=noninteractive \
  TERM=xterm

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
	git \
    gnupg2 \
    mesa-utils \
    python3-pip \
    python-pip \
    software-properties-common \
    sudo \
    tmux \
    wget \
    xserver-xorg
RUN dpkg-reconfigure xserver-xorg

# Install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall

# install vim-8.2
RUN add-apt-repository ppa:jonathonf/vim -y && apt-get update &&\
	apt-get install -y \
	vim && rm -rf /var/lib/apt/lists/*

RUN pip3 install ranger-fm

# Use the default user
RUN useradd -rms /usr/bin/zsh -u $UID ${USER} && echo ${USER}:${USR_PWD} | chpasswd
RUN adduser ${USER} sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoer

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    zsh

# Install oh-my-zsh, Default powerline10k theme, no plugins installed
# RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.2/zsh-in-docker.sh)"

RUN apt-get install -y \
    ros-melodic-rviz \
    libgoogle-glog-dev

RUN chmod o+rwx /usr/local/zed

RUN apt-get install -y \
    cargo \
	clang-format \
	exuberant-ctags

RUN cargo install ripgrep

USER $USER

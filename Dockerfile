FROM tiryoh/ros-melodic-desktop

ARG UID=1000
ARG USR_PWD=bot
ARG USER="bot"

USER root

# Setup environment
RUN apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV \
  LANG=en_US.UTF-8 \
  DEBIAN_FRONTEND=noninteractive \
  TERM=xterm

RUN apt-get remove -y --purge xserver-xorg

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    gnupg2 \
    mesa-utils \
    sudo \
    tmux \
	git \
	zsh \
    wget \
    xserver-xorg

RUN dpkg-reconfigure xserver-xorg

# Install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall

# Default powerline10k theme, no plugins installed
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.2/zsh-in-docker.sh)"

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/*
RUN add-apt-repository ppa:jonathonf/vim -y && apt-get update &&\
	apt-get install -y \
	vim \
	exuberant-ctags \
	clang-format \
    python3-pip \
 && rm -rf /var/lib/apt/lists/*

RUN useradd -rms /usr/bin/zsh -u $UID $USER && echo ${USER}:${USR_PWD} | chpasswd
RUN adduser ${USER} sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoer

COPY --chown=bot:bot .vim /home/bot/.vim
COPY --chown=bot:bot .config /home/bot/.config
COPY --chown=bot:bot .oh-my-zsh /home/bot/.oh-my-zsh
COPY --chown=bot:bot .zshrc /home/bot/.zshrc

RUN ln -s /home/bot/.vim/.vimrc /home/bot/.vimrc
RUN ln -s /home/bot/.config/tmux/.tmux.conf /home/bot/.tmux.conf
RUN echo ". /home/bot/.config/custom.zshrc" >> /home/bot/.zshrc

RUN pip3 install ranger-fm

# Install ROS packages
# https://unix.stackexchange.com/a/391112
COPY packages.txt packages.txt
RUN add-apt-repository -y ppa:borglab/gtsam-release-4.0 &&\
    apt-get update && apt-get install -y \
    cargo \
    libgtsam-dev \
    libgtsam-unstable-dev &&\
    xargs -a packages.txt apt-get install -y

COPY --chown=bot:bot .local /home/bot/.local

USER $USER

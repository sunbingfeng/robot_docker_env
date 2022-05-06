From ubuntu:14.04

ARG UID=1000
ARG USER=bot
ARG USR_PWD=$USER

# Setup environment
RUN apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV \
  LANG=en_US.UTF-8 \
  DEBIAN_FRONTEND=noninteractive \
  TERM=xterm

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    mesa-utils \
    software-properties-common \
    sudo \
    wget \
    xserver-xorg
RUN dpkg-reconfigure xserver-xorg

# Use the default user
RUN useradd -rms /usr/bin/zsh -u $UID ${USER} && echo ${USER}:${USR_PWD} | chpasswd
RUN adduser ${USER} sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoer

USER $USER

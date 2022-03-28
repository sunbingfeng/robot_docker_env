FROM tiryoh/ros-melodic-desktop

ARG ros1=melodic
ENV ROS1_DISTRO ${ros1}
ENV USER bot

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

# Install ROS packages
# RUN apt-get update && \
#     apt-get install -y \
#     ros-${ROS1_DISTRO}-desktop

# Install dependencies
# https://unix.stackexchange.com/a/391112
# COPY packages.txt packages.txt
# RUN apt-get update && \
#     xargs -a packages.txt apt-get install -y

# ==================

# RUN rosdep init
# USER $USER
# RUN echo ". /opt/ros/${ROS1_DISTRO}/setup.bash" >> /home/${USER}/.bashrc
# RUN rosdep update
# USER root

# # Workspace
# RUN mkdir -p /catkin_ws/src/ && \
#     chown -R $USER /catkin_ws

# WORKDIR /catkin_ws/

# RUN usermod -a -G video $USER
# RUN usermod -a -G dialout $USER

# Default powerline10k theme, no plugins installed
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.2/zsh-in-docker.sh)"

RUN apt-get update

RUN useradd -ms /usr/bin/zsh $USER

USER $USER

FROM tiryoh/ros-melodic-desktop

ARG UID=1000
ARG USER=bot
ARG USR_PWD=$USER

USER root

# Setup environment
RUN apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV \
  LANG=en_US.UTF-8 \
  DEBIAN_FRONTEND=noninteractive \
  TERM=xterm

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    cargo \
	clang-format \
	exuberant-ctags \
	git \
    gnupg2 \
    mesa-utils \
    python3-pip \
    python-pip \
    software-properties-common \
    sudo \
    tmux \
    wget \
    xserver-xorg \
	zsh 
RUN dpkg-reconfigure xserver-xorg

# install GTSAM
RUN add-apt-repository -y ppa:borglab/gtsam-release-4.0 &&\
    apt-get update && apt-get install -y \
    libgtsam-dev \
    libgtsam-unstable-dev && \
    rm -rf /var/lib/apt/lists/*

# Install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall

# Install oh-my-zsh, Default powerline10k theme, no plugins installed
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.2/zsh-in-docker.sh)"

# install vim-8.2
RUN add-apt-repository ppa:jonathonf/vim -y && apt-get update &&\
	apt-get install -y \
	vim && rm -rf /var/lib/apt/lists/*

RUN pip3 install ranger-fm

# install ros packages
COPY packages.txt packages.txt
RUN apt-get update && xargs -a packages.txt apt-get install -y

# Use the default user
RUN useradd -rms /usr/bin/zsh -u $UID ${USER} && echo ${USER}:${USR_PWD} | chpasswd
RUN adduser ${USER} sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoer

COPY --chown=$USER:$USER .vim /home/$USER/.vim
COPY --chown=$USER:$USER .config /home/$USER/.config
COPY --chown=$USER:$USER .oh-my-zsh /home/$USER/.oh-my-zsh
COPY --chown=$USER:$USER .zshrc /home/$USER/.zshrc

RUN ln -s /home/$USER/.vim/.vimrc /home/$USER/.vimrc
RUN ln -s /home/$USER/.config/tmux/.tmux.conf /home/$USER/.tmux.conf
RUN echo ". /home/$USER/.config/custom.zshrc" >> /home/$USER/.zshrc

COPY --chown=$USER:$USER .local /home/$USER/.local
COPY --chown=$USER:$USER .ssh /home/$USER/.ssh

RUN cd /home/$USER/.local/bin && ln -s /home/$USER/.local/bin/git-identity-repo/git-identity git-identity


#### New commands put after here, and they will be cleaned up later.
RUN pip install yapf pandas
RUN apt-get update && apt-get install -y htop

USER $USER

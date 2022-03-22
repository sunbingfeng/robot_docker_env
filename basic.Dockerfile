From ros:melodic

RUN apt-get update && apt-get install -y \
    aufs-tools \
    automake \
    build-essential \
    curl \
    git \
    iputils-ping \
    python3 \
    python3-pip \
    tmux \
    zsh \
 && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | zsh -
RUN curl -fsSL https://raw.github.com/sunbingfeng/dot-vim/master/setup.sh | zsh -

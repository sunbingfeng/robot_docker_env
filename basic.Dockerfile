From ros:melodic

ARG UID=1000
ENV USER="ubuntu"
RUN useradd -u $UID -ms /bin/bash $USER

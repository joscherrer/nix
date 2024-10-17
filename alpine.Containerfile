FROM docker.io/alpine:3

RUN apk add --no-cache \
    bash \
    zsh \
    curl \
    jq \
    git \
    openssh-client \
    rsync \
    tar \
    unzip \
    zip \
    neovim \
    tmux \
    ripgrep \
    fzf \
    postgresql16-client \
    shellcheck \
    yq-go \
    xdg-utils \
    make \
    cmake \
    bind-tools \
    cargo \
    lua \
    htop \
    findutils

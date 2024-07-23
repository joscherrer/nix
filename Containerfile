FROM registry.access.redhat.com/ubi9/ubi:9.4

RUN dnf install -y git sudo xz gzip && \
    adduser -m -s /bin/bash jscherrer && \
    echo "jscherrer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER jscherrer
ENV USER=jscherrer
WORKDIR /home/jscherrer
RUN curl -L https://nixos.org/nix/install | sh -s -- --no-daemon

COPY --chown=jscherrer:jscherrer . /home/jscherrer/.config/home-manager

RUN mkdir -p ~/.config/nix && \
    . /home/jscherrer/.nix-profile/etc/profile.d/nix.sh && \
    nix --extra-experimental-features "nix-command flakes" run home-manager/master -- init --switch
#
# USER jscherrer
# RUN mkdir -p ~/.config/nix && \
#     echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf && \
#     nix run home-manager/release-24.05 -- init --switch




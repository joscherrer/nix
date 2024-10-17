FROM registry.access.redhat.com/ubi9/ubi:9.4

RUN dnf install -y git sudo xz gzip && \
    adduser -m -s /bin/bash jscherrer && \
    echo "jscherrer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER jscherrer
ENV USER=jscherrer
WORKDIR /home/jscherrer

COPY --chown=jscherrer:jscherrer . /home/jscherrer/.config/home-manager

RUN curl -L https://nixos.org/nix/install | sh -s -- --no-daemon && \
    mkdir -p ~/.config/nix && \
    . /home/jscherrer/.nix-profile/etc/profile.d/nix.sh && \
    echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf && \
    # nix --extra-experimental-features "nix-command flakes" run home-manager/master -- init --switch
    nix run home-manager/master -- -b bak init --switch --flake "/home/jscherrer/.config/home-manager#jscherrer" && \
    nix-store --optimise && \
    nix-collect-garbage -d
#
# USER jscherrer
# RUN mkdir -p ~/.config/nix && \
#     echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf && \
#     nix run home-manager/release-24.05 -- init --switch




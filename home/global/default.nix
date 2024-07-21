{ inputs, lib, pkgs, config, outputs, ... }:
{
  imports = [
    ./minimal.nix
    ../../lib
    ./languages
  ];


  home.packages = with pkgs; [
    # IaC/Cloud
    terraform
    terraform-ls
    packer
    ansible
    ansible-lint
    hcloud
    google-cloud-sdk
    gh
    scaleway-cli
    s3cmd
    awscli2
    fluxcd
    vault-bin
    stable.open-policy-agent
    ibmcloud-cli
    minio-client
    natscli
    postgresql

    # Containers
    podman-compose
    dive
    kustomize
    kubectl
    kubectx
    kubelogin-oidc
    kind
    stable.hadolint
    kubernetes-helm
    helm-docs
    kubernetes-helmPlugins.helm-diff
    kubetail
    k9s

    # Python
    (python3.withPackages (ps: with ps; [
      flake8
      ruamel-yaml
      requests
      toml
      types-toml
      sh
    ]))
    black
    mypy
    # python311Packages.virtualenv


    # Nix
    niv
    nil

    # Dev misc
    openapi-generator-cli
    caddy
    termscp
    marksman

    # Video
    ffmpeg
    x264
    x265

  ];
}

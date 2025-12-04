{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}:
{
  imports = [
    ./minimal.nix
    ../../lib
    ./languages
  ];

  programs.k9s = {
    enable = true;
  };

  home.packages = with pkgs; [
    # IaC/Cloud
    terraform
    opentofu
    tofu-ls
    terraform-ls
    terraform-docs
    packer
    # ansible
    # ansible-lint
    hcloud
    google-cloud-sdk
    gh
    scaleway-cli
    s3cmd
    awscli2
    fluxcd
    argocd
    vault-bin
    open-policy-agent
    ibmcloud-cli
    minio-client
    azure-cli
    natscli
    postgresql
    pv-migrate
    grafana-alloy
    # cloudflared

    # Containers
    # podman-compose
    docker-compose
    unstable.dive
    kustomize
    kubectl
    kubectl-explore
    krew
    kubectx
    kubelogin-oidc
    kind
    stable.hadolint
    kubernetes-helm
    helm-docs
    kubernetes-helmPlugins.helm-diff
    kubetail
    clusterctl
    talosctl

    tmuxp
    black
    mypy
    basedpyright

    # Dev misc
    openapi-generator-cli
    caddy
    termscp
    marksman
    k6

    # kube-prometheus
    go-jsonnet
    jsonnet-bundler
    jsonnet-language-server
    gojsontoyaml

    # Video
    ffmpeg
    x264
    x265

  ];
}

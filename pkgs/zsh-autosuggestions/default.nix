{ lib, stdenv, fetchFromGitHub, zsh, sources ? import ../../nix/sources.nix }:

let
  zsh-autosuggestions-src = sources.zsh-autosuggestions;
  entrypoint = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
  nixpkgs = sources.nixpkgs { };
in
stdenv.mkDerivation rec {
  pname = "zsh-autosuggestions";
  version = "master";

  src = zsh-autosuggestions-src;

  strictDeps = true;
  buildInputs = [ zsh ];

  installPhase = ''
    install -D zsh-autosuggestions.zsh \
      "$out/${entrypoint}"
  '';

  meta = with lib; {
    description = "Fish shell autosuggestions for Zsh";
    homepage = "https://github.com/zsh-users/zsh-autosuggestions";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.joscherrer ];
  };

  passthru = {
    entrypoint = entrypoint;
  };
}

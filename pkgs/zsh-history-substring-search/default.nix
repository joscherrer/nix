{ stdenv, lib, fetchFromGitHub, sources ? import ../../nix/sources.nix }:

let
  zsh-history-substring-search-src = sources.zsh-history-substring-search;
  entrypoint = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
  nixpkgs = sources.nixpkgs { };
in
stdenv.mkDerivation rec {
  pname = "zsh-history-substring-search";
  version = "master";

  src = zsh-history-substring-search-src;

  strictDeps = true;
  installPhase = ''
    install -D zsh-history-substring-search.zsh \
      "$out/${entrypoint}"
  '';

  meta = with lib; {
    description = "Fish shell history-substring-search for Zsh";
    homepage = "https://github.com/zsh-users/zsh-history-substring-search";
    license = licenses.bsd3;
    maintainers = with maintainers; [ joscherrer ];
    platforms = platforms.unix;
  };

  passthru = {
    entrypoint = entrypoint;
  };
}

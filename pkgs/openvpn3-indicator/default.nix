{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  python3,
  gtk3,
  zip,
  gobject-introspection,
  wrapGAppsHook3,
  libayatana-appindicator,
  libsecret,
  openvpn3,
}:

let
  pythonEnv = python3.withPackages (
    ps: with ps; [
      pygobject3
      secretstorage
      setproctitle
      dbus-python
    ]
  );
in
stdenv.mkDerivation rec {
  pname = "openvpn3-indicator";
  version = "git-d464ef5"; # you can change this to a tag/real version if you prefer

  src = fetchFromGitHub {
    owner = "OpenVPN";
    repo = "openvpn3-indicator";
    rev = "main";
    sha256 = "sha256-KK/ZrVsPJtjJtmRGhxVW/gCFTv759qzlPZHKVMg7pKU=";
  };

  pythonPath = [
    openvpn3
  ];

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook3
    gobject-introspection
    zip
    python3
  ];

  buildInputs = [
    pythonEnv
    gtk3
    libayatana-appindicator
    libsecret
    openvpn3
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "scripts/build_executable" "${pythonEnv}/bin/python3 scripts/build_executable"
  '';

  # No compilation, it’s installed by the Makefile.
  buildPhase = ''
    runHook preBuild
    make DESTDIR=dest PREPAREDIR=prepare PREFIX= HARDCODE_PYTHON=python3 package
    glib-compile-schemas dest/share/glib-2.0/schemas
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r dest/* $out/
    runHook postInstall
  '';

  # Ensure the script finds python + GI modules at runtime
  postFixup = ''
    wrapProgram $out/bin/openvpn3-indicator \
      --set PYTHON ${pythonEnv}/bin/python3 \
      --prefix PATH : ${lib.makeBinPath [ pythonEnv ]} \
      --prefix PYTHONPATH : ${openvpn3}/lib/python3.13/site-packages
  '';

  meta = with lib; {
    description = "Simple GTK indicator GUI for OpenVPN 3 Linux";
    homepage = "https://github.com/OpenVPN/openvpn3-indicator";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}

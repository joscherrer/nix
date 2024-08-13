{
  lib,
  appimageTools,
  fetchurl,
}:

let
  version = "1.0.0";
  pname = "ankama-launcher";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://launcher.cdn.ankama.com/installers/production/Ankama%20Launcher-Setup-x86_64.AppImage";
    hash = "sha256-aTzTQRwIpP87rn/GJ958y9nKbkuZ1wai2a4oNBLJ7bU=";
  };

  appimageContents = appimageTools.extractType1 { inherit name src; };
in
appimageTools.wrapType1 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/zaap.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/zaap.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname} --ozone-platform-hint=wayland --log-file /tmp/zaap.log'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = {
    description = "Ankama Launcher";
    homepage = "https://dofus.com";
    downloadPage = "https://dofus.com";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ onny ];
    platforms = [ "x86_64-linux" ];
  };
}


{ lib, stdenv, fetchurl, appimageTools, makeWrapper, electron }:
stdenv.mkDerivation rec {
  pname = "remnote";
  version = "1.3.15";

  src = fetchurl {
    url = "https://download.remnote.io/RemNote-${version}.AppImage";
    sha256 = "0nkrwr8sp14bwlq61km1b7ibxxxrnhhif3x65y2sj3fj90vskpsn";
    name = "${pname}-${version}.AppImage";
  };

  appimageContents = appimageTools.extract {
    name = "${pname}-${version}";
    inherit src;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/${pname} $out/share/applications

    cp -a ${appimageContents}/{locales,resources,usr} $out/share/${pname}
    cp -a ${appimageContents}/remnote.desktop $out/share/applications/${pname}.desktop


    install -m 444 -D resources/app.asar $out/share/${pname}/app.asar

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${pname}' \
      --replace 'Icon=remnote' Icon=$out/share/${pname}/usr/share/icons/hicolor/512x512/apps/remnote.png
   runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app
  '';


  meta = with lib; {
    description = "A local-first, non-linear, outliner notebook for organizing and sharing your personal knowledge base";
    homepage = "https://github.com/logseq/logseq";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ weihua ];
    platforms = [ "x86_64-linux" ];
  };
}

(self: super:

  {
    logseq = super.logseq.overrideAttrs (old: rec {
      pname = "logseq";
      version = "0.4.2";

      src = super.fetchurl {
        url = "https://github.com/logseq/logseq/releases/download/${version}/logseq-linux-x64-${version}.AppImage";
        sha256 = "0yf9d83gwlipswjrj07wj3s51lr2pji48xvcw1xllzj61dqx4h04";
        name = "${pname}-${version}.AppImage";
      };

      appimageContents = super.appimageTools.extract {
        name = "${pname}-${version}";
        inherit src;
      };

      dontUnpack = true;
      dontConfigure = true;
      dontBuild = true;

      nativeBuildInputs = [ self.makeWrapper ];

      installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/${pname} $out/share/applications
    cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
    cp -a ${appimageContents}/Logseq.desktop $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace Exec=Logseq Exec=${pname} \
      --replace Icon=Logseq Icon=$out/share/${pname}/resources/app/icons/logseq.png
    runHook postInstall
  '';

      postFixup = ''
    makeWrapper ${super.electron_13}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app
  '';

#      version = "0.3.8";
#      pname = "logseq";
#      src = super.fetchurl {
#        url =
#          "https://github.com/logseq/logseq/releases/download/${version}/${pname}-linux-x64-${version}.AppImage";
#        sha256 =
#          #"77541028a03d177ab70c1e95c17189e651a4469f45bd04e74b3b83e63d81a7c7";
#          "07hxs0a3b6k2gw6s1pxrs13zjqljbpdclnssxk3cpaw463jyd7s3";
#        name = "${pname}-${version}.AppImage";
#      };
#
#      appimageContents = super.appimageTools.extract {
#        name = "${pname}-${version}";
#        inherit src;
#      };
#      # we have to include this becuase it refernces the appimageContents we just produced
#      installPhase = ''
#        runHook preInstall
#        mkdir -p $out/bin $out/share/${pname} $out/share/applications
#        cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
#        cp -a ${appimageContents}/Logseq.desktop $out/share/applications/${pname}.desktop
#        substituteInPlace $out/share/applications/${pname}.desktop \
#          --replace Exec=Logseq Exec=${pname} \
#          --replace Icon=Logseq Icon=$out/share/${pname}/resources/app/icons/logseq.png
#        runHook postInstall
#      '';
    });
  })

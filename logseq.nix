(self: super:

  {
    logseq = super.logseq.overrideAttrs (old: rec {
      version = "0.3.2";
      pname = "logseq";
      src = super.fetchurl {
        url =
          "https://github.com/logseq/logseq/releases/download/${version}/${pname}-linux-x64-${version}.AppImage";
        sha256 =
          #"77541028a03d177ab70c1e95c17189e651a4469f45bd04e74b3b83e63d81a7c7";
          "022q7g0pqiijqvinx2nr1b33p1fclaqzdlqvl6ywjhlkgc3sj1g2";
        name = "${pname}-${version}.AppImage";
      };

      appimageContents = super.appimageTools.extract {
        name = "${pname}-${version}";
        inherit src;
      };
      # we have to include this becuase it refernces the appimageContents we just produced
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
    });
  })

self: pkgs:
with builtins;
let
  assetsAll = fromJSON (readFile ./github.release.latest.prefetched.json);
  assetsLinux = filter (p: p.platform == "linux") assetsAll;
  p = head assetsLinux;
in
  {
    pandoc-bin = pkgs.stdenv.mkDerivation {
      name         = p.nameCore;
      version      = p.version;
      src          = fetchurl p.urlsha;
      installPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/etc/bash_completion.d
        install -D -m555 -T bin/pandoc $out/bin/pandoc
        install -D -m555 -T bin/pandoc-citeproc $out/bin/pandoc-citeproc
        $out/bin/pandoc --bash-completion > $out/etc/bash_completion.d/pandoc-completion.bash
        cp -a share $out
      '';
    };
  }


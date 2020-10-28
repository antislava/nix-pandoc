self: pkgs:
with builtins;
let
  assetsAll = with builtins; fromJSON (readFile ./github.release.latest.prefetched.json);
  assetsLinux = builtins.filter (p: p.platform or "" == "linux-amd64") assetsAll;
  p = builtins.head assetsLinux;
in
  {
    pandoc-bin = pkgs.stdenv.mkDerivation {
      name         = p.nameCore;
      version      = p.version;
      src          = builtins.fetchurl p.urlsha;
      installPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/etc/bash_completion.d
        install -D -m555 -T bin/pandoc $out/bin/pandoc
        $out/bin/pandoc --bash-completion > $out/etc/bash_completion.d/pandoc-completion.bash
        cp -a share $out
      '';
        # install -D -m555 -T bin/pandoc-citeproc $out/bin/pandoc-citeproc # REPLACED with pandoc --citeproc!
    };
  }


let
  release = with builtins; fromJSON (readFile ./github.release.latest.json);
  # map (p: p.name) release.assets
  extractAsset = a:
  let i = builtins.match
          "^([a-zA-Z]+)-([0-9\.]+)(-([0-9]+))?-([^\.]+).(.*)$" a.name;
# "pandoc-2.7.2-1-amd64.deb"
#      -> [ "pandoc" "2.7.2" "-1" "1" "amd64" "deb" ]
# "pandoc-2.7.2-linux.tar.gz"
#      -> [ "pandoc" "2.7.2" null null "linux" "tar.gz" ]
    in if i == null then {} else {
      nameCore  = builtins.elemAt i 0;
      version   = builtins.elemAt i 1;
      platform  = builtins.elemAt i 4;
      extension = builtins.elemAt i 5;
      urlsha = {
        url    = a.browser_download_url;
        sha256 = "$(nix-prefetch-url ${a.browser_download_url})";
      };
      # data = a;
    };
in
  # filter (a: a ? "nameCore") (map extractAsset release.assets)
  # Keeping only linux binaries (TODO control this by a input variable)
  builtins.filter (a: a.platform or "" == "linux-amd64")
    (map extractAsset release.assets)

with builtins;
let
  release = fromJSON (readFile ./github.release.latest.json);
  extractAsset = a:
    let i = match "^([a-zA-Z]+)-([0-9\.]+)(-([0-9]+))?-([^\.]+).(.*)$" a.name;
# "pandoc-2.7.2-1-amd64.deb"
#      -> [ "pandoc" "2.7.2" "-1" "1" "amd64" "deb" ]
# "pandoc-2.7.2-linux.tar.gz"
#      -> [ "pandoc" "2.7.2" null null "linux" "tar.gz" ]
    in {
      nameCore  = elemAt i 0;
      version   = elemAt i 1;
      platform  = elemAt i 4;
      extension = elemAt i 5;
      urlsha = {
        url    = a.browser_download_url;
        sha256 = "$(nix-prefetch-url ${a.browser_download_url})";
      };
      # data = a;
    };
in
  map extractAsset release.assets

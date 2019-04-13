with import <nixpkgs> { overlays = [ (import ./.) ] ;};
runCommand "pandoc" rec {
  buildInputs = [ pandoc-bin ];
  # TODO: Putting shell completions into the profile when installed
  # https://github.com/NixOS/nixpkgs/issues/44434#issuecomment-410624170
  # ls $HOME/.nix-profile/etc/bash_completion.d
  shellHook = ''
    echo "Pandoc shell"
    echo "Loading bash completions:"
    '' + (
      builtins.concatStringsSep "\n" (
        map (p:
        ''
          for e in ${p}/etc/bash_completion.d/*
          do
            echo `basename $e`
            source $e
          done
        '') buildInputs
      ));
} ""

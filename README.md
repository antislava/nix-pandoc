# Nix overlay with `Pandoc` release binaries

## Makefile

Most commands needed to update and/or generate GitHub release data are coded in the supplied Makefile:

```shell
make help
```

### Making nix shell with the main dependencies

```shell
make shell-dev
```

### Testing the nix-overlay

```shell
make shell-test
# or
nix-shell --pure ./test-shell.nix

pandoc --vesion
pandoc --<TAB> # Autocompletion should work
```

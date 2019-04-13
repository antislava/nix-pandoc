DIR         = .
PANDOC      = $(DIR)/pandoc
PANDOC_LTST = $(PANDOC)/github.release.latest

$(info $(shell mkdir -p $(PANDOC)))

THIS := $(abspath $(lastword $(MAKEFILE_LIST)))

help :
	# @cat $(THIS)
	@bat $(THIS) -l make

.PHONY : shell-dev
shell-dev :
	nix-shell -p jq shab

$(PANDOC_LTST).json :
	curl -L https://api.github.com/repos/jgm/pandoc/releases/latest > $@

$(PANDOC_LTST).prefetched.json : $(PANDOC_LTST).json
	nix eval "(import $(PANDOC)/prefetch-assets.nix)" --json | shab | jq -r > $@

.PHONY : shell-test
shell-test :
	nix-shell ./test-shell.nix

# ########################################################################
# Switched from jq (below) to nix eval for better consistency
# $(SRC_URL)/%.github.release.linux.json : $(SRC_URL)/%.github.release.json
# 	jq '{ name, tag_name, created_at, "assets": [ .assets[] | select(.name | contains("linux") and contains("tar")) | { name, url: .browser_download_url, sha256: ("$$(nix-prefetch-url " + .browser_download_url +")") } ] }' $< | shab > $@

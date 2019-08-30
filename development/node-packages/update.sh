#! /usr/bin/env bash

set -e

# see https://stackoverflow.com/a/246128/5354298
get_script_dir() { cd "$( dirname "${BASH_SOURCE[0]}" )"; echo "$( pwd )"; }

# see https://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
is_installed() { hash $1 2>/dev/null || { false; } }
exit_if_not_installed() { is_installed $1 || { echo >&2 "I require $1 but it's not installed. Aborting. See https://nixos.org/nix/manual/#sec-prerequisites-source."; exit 1; } }
function ensure_installed() {
	if ! is_installed $1 ; then
		echo "Installing missing dependency $1...";
		$2;
	fi
}

SCRIPT_DIR="$(get_script_dir)"

echo "installing/updating node packages"

echo "ensuring nix is installed and up to date...";
exit_if_not_installed nix-channel;
exit_if_not_installed nix-env;
nix-channel --update

ensure_installed node "nix-env -f <nixpkgs> -i nodejs";
ensure_installed node2nix "nix-env -f <nixpkgs> -iA nodePackages.node2nix";
ensure_installed jq "nix-env -f <nixpkgs> -i jq";

cd "$SCRIPT_DIR";

rm -f node-env.nix;

node2nix -6 -i node-packages-v6.json -o node-packages-v6.nix -c composition-v6.nix
node2nix -8 -i node-packages-v8.json -o node-packages-v8.nix -c composition-v8.nix
node2nix --nodejs-10 -i node-packages-v10.json -o node-packages-v10.nix -c composition-v10.nix

# TODO: look at whether to use a lock file somehow.
#rm -f default.nix node-packages.nix node-env.nix;
#jq '[.dependencies | to_entries | .[] | {(.key): .value}]' package.json > node-packages.json 
#npm shrinkwrap
#cp npm-shrinkwrap.json package-lock.json
#node2nix -6 -i "$SCRIPT_DIR/node-packages.json" -l "$SCRIPT_DIR/npm-shrinkwrap.json"
#nix-env -f default.nix -i

# TODO: why isn't bridgedb installing with version 8?
#node2nix -8 --bypass-cache -i "$SCRIPT_DIR/node-packages.json"
#node2nix -6 -i "$SCRIPT_DIR/node-packages.json"

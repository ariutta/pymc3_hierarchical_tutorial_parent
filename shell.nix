{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:
let
  deps = import ./deps.nix;
in
  pkgs.mkShell {
    buildInputs = deps;
    shellHook = ''
      bash ./shell-hook.sh

      # To open as a jupyter notebook:
      # jupyter notebook --port=8888 --notebook-dir ./
    '';
}

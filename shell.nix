{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:
with pkgs.lib.strings;
let
  deps = import ./deps.nix;
  shellHookBase = fileContents ./shell-hook.sh;
in
  pkgs.mkShell {
    buildInputs = deps;
    shellHook = concatStringsSep "\n" [
      shellHookBase
      ''
        # To open as a jupyter notebook:
        # jupyter notebook --port=8888 --notebook-dir ./pymc3_hierarchical_tutorial
      ''
    ];
}

{ pkgs ? import <nixpkgs> {} }:
with pkgs.lib.strings;
let
  deps = import ./deps.nix;
  shellHookBase = fileContents ./shell-hook-base.sh;
  startServer = fileContents ./start-server.sh;
in
  pkgs.mkShell {
    buildInputs = deps ++ [ pkgs.ps ];
    shellHook = concatStringsSep "\n" [
      shellHookBase
      startServer
    ];
}

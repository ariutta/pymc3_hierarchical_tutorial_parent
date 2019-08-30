# See README.md for instructions on installing/updating.

with import <nixpkgs> { config.allowUnfree = true; };
let
  common = import ./common.nix;
  custom = import ../all-custom.nix;
in common ++ [

  pkgs.python3
  pkgs.pypi2nix
  custom.black

] ++ (if stdenv.isDarwin then [

  # XCode Command Line Tools
  # TODO: do we need cctools?
  #pkgs.darwin.cctools

] else [

])

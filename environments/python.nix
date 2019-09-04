# See README.md for instructions on installing/updating.

with import <nixpkgs> { config.allowUnfree = true; };
let
  common = import ./common.nix;
  custom = import ../all-custom.nix;
in common ++ [
  # Install python and packages like this:
  #python3.withPackages(ps: with ps; [ numpy toolz ])
  #
  # Not like this:
  #pkgs.python3
  #pkgs.python3Packages.numpy
  #pkgs.python3Packages.toolz
  #
  # More information:
  # https://nixos.org/nixpkgs/manual/#using-python

  # Only include command-line tools here
  pkgs.pypi2nix
  custom.black
] ++ (if stdenv.isDarwin then [

  # XCode Command Line Tools
  # TODO: do we need cctools?
  #pkgs.darwin.cctools

] else [

])

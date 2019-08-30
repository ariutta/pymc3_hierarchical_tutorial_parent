{ pkgs, nodejs, stdenv }:

let
  nodePackages = import ./composition-v10.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages // {
  "@wikipathways/pvjs" = nodePackages."@wikipathways/pvjs".override {
    buildInputs = [
      pkgs.libxml2 # for xmllint
      # node-gyp dependencies
      # see https://github.com/nodejs/node-gyp#on-unix
      # (Required for building node-expat)
      pkgs.python2
    ] ++ (if stdenv.isDarwin then [
      # more node-gyp dependencies
      # XCode Command Line Tools
      # TODO: do we need cctools?
      #pkgs.darwin.cctools
    ] else [
      # more node-gyp dependencies

      pkgs.gnumake

      # gcc and binutils disagree on the version of one or more
      # dependencies, so we need to use binutils-unwrapped
      # instead of just binutils (binutils-wrapped).
      pkgs.gcc # also provides cc
      pkgs.binutils-unwrapped # provides ar
    ]);
  };
}

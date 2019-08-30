# Related
# Installing manually on older OS/X:
# http://www.andrewwatters.com/privoxy/
# NixOS service:
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/networking/privoxy.nix
# Nix package:
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/tools/networking/privoxy/default.nix
# Homebrew package:
# https://github.com/Homebrew/homebrew-core/blob/master/Formula/privoxy.rb

# TODO Is the plist file correct to make this startup as a service?
# TODO use nix-darwin to make this work as a service
# https://github.com/LnL7/nix-darwin

{ pkgs, stdenv }:

pkgs.privoxy.overrideAttrs (oldAttrs: {
  postInstall = pkgs.privoxy.postInstall + (if stdenv.isDarwin then ''
    mkdir -p $out/Library/LaunchDaemons
    cp ${./org.nixos.privoxy.plist} $out/Library/LaunchDaemons/org.nixos.privoxy.plist
    substituteInPlace $out/Library/LaunchDaemons/org.nixos.privoxy.plist --subst-var out
    echo 'To launch this manually, run:'
    echo 'sudo launchctl load -w $(dirname $(dirname $(readlink $(which privoxy))))/Library/LaunchDaemons/org.nixos.privoxy.plist'
  ''
  else ''
  ''
  );
})

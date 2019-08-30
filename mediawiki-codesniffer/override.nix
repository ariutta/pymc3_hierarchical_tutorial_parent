{pkgs ? import <nixpkgs> {
  inherit system;
}, system ? builtins.currentSystem}:

let
  phpPackage = import ./default.nix {
    inherit pkgs system;
  };
in
phpPackage.override {
  postInstall = ''
    phpcs --config-set installed_paths "/nix/store/xiax05l1yd2qj6jrp3m7x25r2k1rl1pk-composer-mediawiki-mediawiki-codesniffer/share/php/composer-mediawiki-mediawiki-codesniffer/vendor/mediawiki/mediawiki-codesniffer/MediaWiki/ruleset.xml"
  '';
}

with import <nixpkgs> { config.allowUnfree = true; };

let
  nodePackages = import ./default.nix {};
in
{
  bridgedb = nodePackages."bridgedb-6.0.2";
  gpml2pvjson = nodePackages."gpml2pvjson-4.1.1";
  pvjs = nodePackages."@wikipathways/pvjs-4.0.4";
}

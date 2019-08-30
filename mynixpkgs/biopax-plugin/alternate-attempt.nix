{ stdenv, pkgs, mavenbuild, PathVisio, biopax3 }:

with pkgs.javaPackages;

let
  poms = import ../poms.nix { inherit fetchMaven; };
in rec {
  BiopaxPluginRec = { mavenDeps, sha512, version, skipTests ? true, quiet ? true }: mavenbuild rec {
    inherit mavenDeps sha512 version skipTests quiet;

    name = "biopax-plugin-${version}";
    src = pkgs.fetchFromGitHub {
      inherit sha512;
      owner = "PathVisio";
      repo = "biopax-plugin";
      rev = "v${version}";
    };
    m2Path = "/com/PathVisio/biopax-plugin/${version}";

    meta = {
      homepage = https://github.com/PathVisio/biopax-plugin;
      description = "PathVisio plugin to import and export pathways in BioPAX format";
      license = stdenv.lib.licenses.apache2;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers;
        [ pathvisio ];
    };
  };

  BiopaxPlugin_3 = BiopaxPluginRec {
    mavenDeps = [];
    sha512 = "3kv5z1i02wfb0l5x3phbsk3qb3wky05sqn4v3y4cx56slqfp9z8j76vnh8v45ydgskwl2vs9xjx6ai8991mzb5ikvl3vdgmrj1j17p2";
    version = "3";
  };
}

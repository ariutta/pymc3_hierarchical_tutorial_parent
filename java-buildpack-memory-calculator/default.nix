{ coreutils, fetchFromGitHub, buildGoPackage }:

with builtins;

buildGoPackage rec {
  name = "java-buildpack-memory-calculator${version}";
  version = "3.13.0";

  goPackagePath = "github.com/cloudfoundry/java-buildpack-memory-calculator";
  #subPackages = [ "client" ];

  src = fetchFromGitHub {
    owner = "cloudfoundry";
    repo = "java-buildpack-memory-calculator";
    rev = "v${version}.RELEASE";
    sha256 = "1yrqkqff9pw9yq3yqil4s8n6r7z2a90p3vcrlc2nh79gkq0648xv";
  };

  buildFlags = "--tags release";
}

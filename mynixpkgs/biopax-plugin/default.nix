{ stdenv, callPackage, fetchurl, fetchFromGitHub, unzip, ant, jdk }:

with builtins;

let
  #custom = callPackage ../all-custom.nix {};
  custom = import ../all-custom.nix;
  baseName = "biopax-plugin";
  version = "180ea7e4d8f178328667bb31779cb2dc2a29cf69";
in
stdenv.mkDerivation rec {
  name = "${baseName}-${version}";

  # should this be nativeBuildInputs or just buildInputs?
  nativeBuildInputs = [ unzip ant jdk ];

  javaPath = "${jdk.jre}/bin/java";

  src = fetchFromGitHub {
    owner = "pathvisio";
    repo = baseName;
    rev = version;
    sha256 = "1rqbvay7kgxc3frrlv5dsji8rig3xc5b8hxc0iy1dh610b6lg1lz";
  };

  pathvisioSrc = fetchFromGitHub {
    owner = "PathVisio";
    repo = "pathvisio";
    rev = "61f15de96b676ee581858f0485f9c6d8f61a3476";
    sha256 = "1n2897290g6kph1l04d2lj6n7137w0gnavzp9rjz43hi1ggyw6f9";
  };

  postPatch = ''
    substituteInPlace ./build.xml \
          --replace "../../common-bundles/trunk/" "${custom.pathvisio}" \
          --replace "../../common-bundles/trunk" "${custom.pathvisio}" \
          --replace 'ant">' 'ant"><path id="embed.jars"></path>'
          #--replace 'ant">' 'ant"><path id="embed.jars"></path><javac includeantruntime="false" srcdir="." destdir="." failonerror="false"/>'
          
    substituteInPlace ./src/org/pathvisio/biopax3/BiopaxFormat.java \
          --replace "public void doExport(File file, Pathway pathway)" "public void haveFun(File file, Pathway pathway)" \
          #--replace "public void doExport" "@Override public void doExport" \
  '';

  #buildPhase = "ant";
  #buildPhase = "ant prepare";
  buildPhase = "ant -k jar";
  #buildPhase = "ant -k compile";

  installPhase = ''
    mkdir -p $out/bin
    cp -r ./ $out/
  '';

  meta = with stdenv.lib;
    { description = "PathVisio plugin to import and export pathways in BioPAX format";
      #broken = true;
      homepage = https://www.pathvisio.org/;
      license = licenses.asl20;
      maintainers = with maintainers; [ ];
      #platforms = with platforms; [ linux darwin ];
      platforms = platforms.all;
    };
}

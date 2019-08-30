{ coreutils,
fetchurl,
stdenv }:

with builtins;

let
  baseName = "sensible-jvm-opts";
  version = "1.0.0";
  custom = import ../all-custom.nix;
  java-buildpack-memory-calculator = custom.java-buildpack-memory-calculator;
in
stdenv.mkDerivation rec {
  name = replaceStrings [" "] ["_"] (concatStringsSep "-" (filter (x: isString x) [baseName version]));

  # aliases for command-line tool binaries
  # that we keep using in production (after
  # the initial unpack/build/install phase).
  # NOTE: not aliasing echo or exit.
  cutAlias="${coreutils}/bin/cut";
  duAlias="${coreutils}/bin/du";
  exprAlias="${coreutils}/bin/expr";
  tailAlias="${coreutils}/bin/tail";
  trAlias="${coreutils}/bin/tr";

  buildInputs = [ coreutils ];

  src = fetchurl {
    url = "https://introcs.cs.princeton.edu/java/11hello/HelloWorld.java";
    sha256 = "1bqvs9maylbja02cc4vxsk063g5qk1j697hqyrgij9v0ihihl0vj";
  };

  unpackPhase = ''
    cp ${src} ./HelloWorld.java
  '';
  
  buildPhase = ''
    mkdir ./bin

    cat > ./bin/sensible-jvm-opts <<EOF
help_re='(\\-h)|(\\-\\-help)'
if [[ "\$1" =~ \$help_re ]];
then
  echo 'usage: sensible-jvm-opts <classpath> [<custom_jvm_opts>]'
  echo 'examples:'
  echo '  sensible-jvm-opts ".:../*.java"'
  echo '  sensible-jvm-opts ".:../*.java" "-Dfile.encoding=UTF-8"'
  exit 0
fi

CLASSPATH=\$1
MAX_MEMORY=\$2
VM_OPTS=\$3

APPLICATION_SIZE_ON_DISK_IN_MB=\`${duAlias} -cm \$(echo \$CLASSPATH | ${trAlias} ':' ' ') | ${tailAlias} -1 | ${cutAlias} -f1\`
loaded_classes=\$(${exprAlias} "400" "*" "\$APPLICATION_SIZE_ON_DISK_IN_MB")
stack_threads=\$(${exprAlias} "15" "+" "\$APPLICATION_SIZE_ON_DISK_IN_MB" "*" "6" "/" "10")

jvm_opts_calc=\$(${java-buildpack-memory-calculator}/bin/java-buildpack-memory-calculator \\
        -loadedClasses \$loaded_classes \\
        -poolType metaspace \\
        -stackThreads \$stack_threads \\
        -totMemory "\$MAX_MEMORY" \\
        -vmOptions "\$VM_OPTS")

echo "\$jvm_opts_calc -Dfile.encoding=UTF-8"
EOF

    chmod a+x ./bin/sensible-jvm-opts
  '';

  doCheck = true;

  checkPhase = ''
    cd ./bin

    expected="-Xmx761278K -Xss1M -XX:ReservedCodeCacheSize=240M -XX:MaxDirectMemorySize=10M -XX:MaxMetaspaceSize=15937K -Dfile.encoding=UTF-8"

    actual1=$(./sensible-jvm-opts ".:../*.java" "1024m" "-Dfile.encoding=UTF-8")
    if [[ "$actual1" != "$expected" ]]; then
      echo "Error: sensible-jvm-opts failed."
      echo "Expected: $expected"
      echo "  Actual: $actual1"
      exit 1;
    fi

    actual2=$(./sensible-jvm-opts "../*.java" "1024m" "-Dfile.encoding=UTF-8")
    if [[ "$actual2" != "$expected" ]]; then
      echo "Error: sensible-jvm-opts failed."
      echo "Expected: $expected"
      echo "  Actual: $actual2"
      exit 1;
    fi

    cd ../
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    cp -r ./bin/* $out/bin/
  '';

  meta = with stdenv.lib;
    { description = "CLI tool to calculate sensible JVM options.";
      longDescription = ''
        For more details, see these refernces:
        * https://docs.oracle.com/cd/E13150_01/jrockit_jvm/jrockit/jrdocs/refman/optionX.html
        * https://medium.com/@matt_rasband/dockerizing-a-spring-boot-application-6ec9b9b41faf
      '';
      #homepage = https://www.pathvisio.org/;
      license = licenses.asl20;
      maintainers = with maintainers; [ ariutta ];
      platforms = platforms.all;
    };
}

{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

let
  packages = {
    "composer/semver" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-semver-c7cb9a2095a074d131b65a8a0cd294479d785573";
        src = fetchurl {
          url = https://api.github.com/repos/composer/semver/zipball/c7cb9a2095a074d131b65a8a0cd294479d785573;
          sha256 = "0rk0xrimzip9zzf5mivdb16yg6wkzv06fipx7aq4iaphcgjqj32j";
        };
      };
    };
    "composer/spdx-licenses" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-spdx-licenses-7e111c50db92fa2ced140f5ba23b4e261bc77a30";
        src = fetchurl {
          url = https://api.github.com/repos/composer/spdx-licenses/zipball/7e111c50db92fa2ced140f5ba23b4e261bc77a30;
          sha256 = "04053za89dhdkrydqxwq85jkm5q4rr3bf30x0vdv1f59hx11hsgp";
        };
      };
    };
    "mediawiki/mediawiki-codesniffer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "mediawiki-mediawiki-codesniffer-e1736ad0c2f5aa384f6488f1906378c0c478f3fc";
        src = fetchurl {
          url = https://api.github.com/repos/wikimedia/mediawiki-tools-codesniffer/zipball/e1736ad0c2f5aa384f6488f1906378c0c478f3fc;
          sha256 = "079qa4zsv6mxbkkxz5jvb7vli3s88jil8g58nd8rpg2rfbz8f7l3";
        };
      };
    };
    "squizlabs/php_codesniffer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "squizlabs-php_codesniffer-4842476c434e375f9d3182ff7b89059583aa8b27";
        src = fetchurl {
          url = https://api.github.com/repos/squizlabs/PHP_CodeSniffer/zipball/4842476c434e375f9d3182ff7b89059583aa8b27;
          sha256 = "0cjn4pqy7vqrm33nan7xvff4kii5w7596n51q6gnmdk1bj3xjhzk";
        };
      };
    };
  };
  devPackages = {};
in
composerEnv.buildPackage {
  inherit packages devPackages noDev;
  name = "mediawiki-mediawiki-codesniffer";
  src = ./.;
  executable = true;
  symlinkDependencies = false;
  meta = {};
}

{ lib, pkgs, buildPythonPackage, python37Packages, fetchgit }:

buildPythonPackage rec {
  pname = "pywikibot";
  version = "3.0.20190722";

  src = fetchgit {
    url = "https://phabricator.wikimedia.org/diffusion/PWBC/";
    rev = "3.0.20190722";
    fetchSubmodules = true;
    sha256 = "1hpabpaas6iyk3wvc70m32nxfyzjznypms9sm5j351zfn21j5a50";
  };

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/shared

    cp ./pwb.py $out/bin/

    cp -r ./scripts $out/shared/scripts
    cp ./generate_user_files.py $out/shared/scripts/
    cp ./generate_family_file.py $out/shared/scripts/

    ln -s $out/shared/scripts $out/bin/scripts
    ln -s $out/lib/python3.7/site-packages/pywikibot $out/shared/scripts/pywikibot
  '';

#  postFixup = ''
#    echo ""
#    echo 'Before using, you'll need to configure Pywikibot:'
#    echo '    pwb.py generate_user_files'
#    echo 'More help: https://www.mediawiki.org/wiki/Manual:Pywikibot/Installation#Configure_Pywikibot'
#    echo ""
#  '';

  doCheck = false;
  buildInputs = [  ];
  propagatedBuildInputs = [ python37Packages.requests ];

  meta = with lib; {
    description = "Python MediaWiki Bot Framework";
    homepage = https://www.mediawiki.org/wiki/Manual:Pywikibot;
    license = licenses.mit;
    maintainers = with maintainers; [ ariutta ];
  };
}

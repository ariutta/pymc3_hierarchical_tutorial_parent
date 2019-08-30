{ stdenv, python3, postgresql }:

let
  inherit (python3.pkgs) buildPythonApplication fetchPypi;
in

buildPythonApplication rec {
  pname = "pgsanity";
  version = "0.2.9";
  name = "${pname}-${version}";

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wrihxhg6yxqcx49w2q5gddazaz2qbm6dx5mkh9zb2zrwipvs2yy";
  };

  propagatedBuildInputs = [
    postgresql
  ];

  meta = with stdenv.lib; {
    description = "Check syntax of postgresql sql files.";
    homepage = "https://github.com/markdrago/pgsanity";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}

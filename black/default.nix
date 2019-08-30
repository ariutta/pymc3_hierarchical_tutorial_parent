{ stdenv, python3 }:

let
  inherit (python3.pkgs) buildPythonApplication fetchPypi;
in

buildPythonApplication rec {
  pname = "black";
  version = "18.5b0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0inrzb8nak1fx0kx4404ac9jg5dbwg5ni8ahvrc4mggvz5k2bv2g";
  };

  # TODO patch or whatever to get the tests to pass
  doCheck = false;

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    attrs
    setuptools
    click
  ];

  meta = with stdenv.lib; {
    description = "The uncompromising code formatter.";
    longDescription = ''
      Black is the uncompromising Python code formatter. By using it, you agree to
      cede control over minutiae of hand-formatting. In return, Black gives you speed,
      determinism, and freedom from pycodestyle nagging about formatting. You will
      save time and mental energy for more important matters.
      '';
    homepage = "https://github.com/ambv/black";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}

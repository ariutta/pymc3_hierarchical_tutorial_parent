{ stdenv, python3 }:

let
  inherit (python3.pkgs) buildPythonApplication fetchPypi;
in

buildPythonApplication rec {
  pname = "tosheets";
  version = "0.3.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "adc149584b38cf795f5a28d6624820e97b76eb115983793adac5a32951ac9de3";
  };

  propagatedBuildInputs = with python3.pkgs; [
    docopt
    google_api_python_client
  ];

  meta = with stdenv.lib; {
    description = "A simple command line utility that sends your stdin to Google sheets.";
    longDescription = ''
      A simple command line utility that sends your stdin to Google sheets.
      Note: on first use, tosheets will open a browser window to authorize OAuth2 token.
      '';
    homepage = "https://github.com/kren1/tosheets";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}

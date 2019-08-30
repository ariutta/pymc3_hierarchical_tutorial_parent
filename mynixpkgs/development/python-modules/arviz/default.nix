{ stdenv, python3 }:

let
  inherit (python3.pkgs) buildPythonApplication fetchPypi;
in

buildPythonApplication rec {
  pname = "arviz";
  version = "0.4.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12gyvq5cpkcvvfdcbwr9f5fqjidk8z3g89xqpw6hycmqykal8imi";
  };

  # TODO get the buildInputs installed in order to run the tests
  doCheck = false;

#  buildInputs = with python3.pkgs; [
#    pytest
#    pymc3
#
##    emcee
##    #git+https://github.com/pymc-devs/pymc3
##    pymc3
##    #ghp-import
##    #pystan
##    #cmdstanpy
##    ipython
##    nbsphinx
##    numpydoc
##    pydocstyle
##    pylint
##    pyro-ppl
##    tensorflow
##    tensorflow-probability
##    pytest
##    #pytest-cov
###    Sphinx
###    sphinx-bootstrap-theme
###    sphinx-gallery
##    black
##    numba
#  ];

  propagatedBuildInputs = with python3.pkgs; [
    matplotlib
    numpy
    scipy
    pandas
    xarray
    netcdf4
  ];

  meta = with stdenv.lib; {
    description = "Exploratory analysis of Bayesian models.";
    longDescription = ''
      ArviZ (pronounced "AR-vees") is a Python package for exploratory analysis
      of Bayesian models. Includes functions for posterior analysis, model
      checking, comparison and diagnostics.
      '';
    homepage = "https://github.com/arviz-devs/arviz";
    license = licenses.asl20;
    maintainers = with maintainers; [ ariutta ];
  };
}

{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:
let
  custom = import ./mynixpkgs/all-custom.nix;
  pythonEnv = import ./mynixpkgs/environments/python.nix;
in
  pkgs.mkShell {
    buildInputs = [
      (pkgs.python3.withPackages (p: [
        p.ipython
        p.jupyter
        p.patsy
        p.numpy
        p.scipy
        p.matplotlib
        # Note: Theano must be capitalized
        p.Theano
        p.pymc3
        p.statsmodels
        p.seaborn
        p.mkl-service
        (with custom.python3Packages; [
          daff
          arviz
        ])
      ]))
      pkgs.hello
    ];
    shellHook = ''
      # Workaround for the following issue:
      # https://github.com/NixOS/nixpkgs/issues/45463#issuecomment-477198263
      export TMP="/tmp/<uid>"
      export TMPDIR="$TMP"
      export TEMP="$TMP"
      export TEMPDIR="$TMP"
      jupyter notebook --no-browser --port=8888
    '';
}

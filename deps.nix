with import <nixpkgs> { config.allowUnfree = true; };
let
  pythonEnv = import ./mynixpkgs/environments/python.nix;
  custom = import ./mynixpkgs/all-custom.nix;
in
  [
    (pkgs.python3.withPackages (p: [
      p.ipython
      p.jupyter
      p.matplotlib
      p.patsy
      p.numpy
      p.scipy
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
  ]

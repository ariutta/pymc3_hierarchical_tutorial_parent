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
      export TMP="/tmp/$(id -u)"
      export TMPDIR="$TMP"
      export TEMP="$TMP"
      export TEMPDIR="$TMP"

      # If session is remote, don't open browser
      # from https://unix.stackexchange.com/a/9607
      if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        SESSION_TYPE=remote/ssh
      else
        case $(ps -o comm= -p $PPID) in
          sshd|*/sshd) SESSION_TYPE=remote/ssh;;
        esac
      fi
      no_browser_flag=""
      if [ "$SESSION_TYPE" == "remote/ssh" ]; then
        no_browser_flag="--no-browser"
      fi
      eval "jupyter notebook $no_browser_flag --port=8888 --notebook-dir ./pymc3_hierarchical_tutorial"
    '';
}

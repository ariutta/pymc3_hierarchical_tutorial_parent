{ pkgs ? import <nixpkgs> {} }:
let
  deps = import ./deps.nix;
in
  pkgs.mkShell {
    buildInputs = deps ++ [ pkgs.ps ];
    shellHook = ''
      bash ./shell-hook.sh

      # If session is remote, don't open browser
      # from https://unix.stackexchange.com/a/9607
      if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        SESSION_TYPE=remote/ssh
      else
        case $(ps -o comm= -p $PPID) in
        sshd | */sshd) SESSION_TYPE=remote/ssh ;;
        esac
      fi
      no_browser_flag=""
      if [ "$SESSION_TYPE" == "remote/ssh" ]; then
        no_browser_flag="--no-browser"
      fi
      eval "jupyter notebook $no_browser_flag --port=8888 --notebook-dir ./pymc3_hierarchical_tutorial"
    '';
}

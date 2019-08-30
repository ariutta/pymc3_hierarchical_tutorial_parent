# See README.md for instructions on installing/updating.
with import <nixpkgs> { config.allowUnfree = true; };
let
  custom = import ../all-custom.nix;
in [
  ####################
  # Deps for powerline
  ####################
  # TODO what is the relationship with Bash-it's powerline theme?
  # https://github.com/Bash-it/bash-it/tree/master/themes/powerline
  # TODO does the powerline package automatically install the powerline fonts?
  pkgs.powerline-fonts

  # NOTE: the PyPi name is powerline-status, but the Nix name is just powerline.
  # NOTE: I added lines to ./.bashrc.public, as instructed here:
  # http://powerline.readthedocs.io/en/master/usage/shell-prompts.html#bash-prompt
  pkgs.python3Packages.powerline

  # To setup keys for GitHub:
  # https://github.com/settings/keys

  # openssh includes ssh-copy-id
  pkgs.openssh

  pkgs.gnupg
  # TODO: do we need gpgme?
  #pkgs.gpgme

  # To see what's included in coreutils, run:
  # info coreutils
  pkgs.coreutils

  # What tools do we want for diffs?
  pkgs.diffutils
  # this works pretty well:
  # wdiff ./a.xml ./b.xml | colordiff
  pkgs.wdiff # word diff (ignore whitespace)
  pkgs.colordiff
  #pkgs.diffoscope

  # load desired environment when entering a directory
  pkgs.direnv

  custom.bash-it
  pkgs.gawkInteractive
  pkgs.gettext
  pkgs.jq
  pkgs.less
  pkgs.nox
  pkgs.ripgrep
  pkgs.rsync
  pkgs.wget

  custom.vim

] ++ (if stdenv.isDarwin then [] else [])

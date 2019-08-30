# pymc3_hierarchical_tutorial_parent

Container for `https://github.com/ariutta/pymc3_hierarchical_tutorial`.

## Install

1. Install [Nix](https://nixos.org/nix/download.html).
2. Clone this repo:

```
git clone https://github.com/ariutta/pymc3_hierarchical_tutorial_parent.git
cd pymc3_hierarchical_tutorial_parent
```

## Launch

If you're running jupyter on your local machine, run `nix-shell` from this directory.
Use `Ctrl-c` jupyter and `Ctrl-d` to exit nix-shell.

If you're jupyter on a remote machine and accessing it via a browser on your local machine,
copy `jupyter-launch-remote` to your local machine and run it.

## mynixpkgs

If you edit files in `mynixpkgs`, you can sync those changes with the source repo:

Setup the `mynixpkgs` subtree, if not done already:

```
git remote add mynixpkgs git@github.com:ariutta/mynixpkgs.git
git subtree add --prefix mynixpkgs mynixpkgs master --squash
```

Sync subtree repo:

```
git subtree pull --prefix mynixpkgs mynixpkgs master --squash
git subtree push --prefix mynixpkgs mynixpkgs master
```

# Cheatsheet for creating custom packages

## Test a package expression

```sh
nix-build -E 'with import <nixpkgs> { }; callPackage ./default.nix {}'
./result/bin/abc --help
```

## Python

Generate Nix expressions for python packages by using pypi2nix, if possible. Otherwise, create manually.
In the future, add these packages to [python-packages.nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/python-packages.nix) and make a pull request.

### Applications

For python packages used as stand-alone applications (even if also used as dependencies):

```sh
mkdir -p tosheets
cd tosheets
pypi2nix -V 3 -e tosheets==0.3.0
```

Then add the package to `./all-custom.nix`.

### Dependency-Only

For packages used only as dependencies (never as stand-alone applications):

```sh
mkdir -p ./development/python-modules/homoglyphs
cd ./development/python-modules/homoglyphs
pypi2nix -V 3 -e homoglyphs==1.2.5
```

Then add the package to `./development/python-modules/python-packages.nix`.

## [Ruby](https://nixos.org/nixpkgs/manual/#sec-language-ruby)

Get or create a Gemfile for the package. Then follow the manual's instructions to run bundix and create a default.nix file. Put the following files under version control:

- default.nix
- Gemfile
- Gemfile.lock
- gemset.nix

## Re-using

Long-term, some of these packages may be included in Nix packages. But for the packages not yet included,
you can use a subtree to pull them into your own project:

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

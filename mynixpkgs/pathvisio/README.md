# PathVisio Build Expression for Nix

Does it work on macOS? There's an open issue for this, so I'm guessing no:
https://github.com/matthewbauer/nix-bundle/issues/17

Take a look at this regarding building non-nixpkgs packages:
https://github.com/matthewbauer/nix-bundle/issues/25

This should work on Linux, but it doesn't currently work on macOS:

```
nix-bundle '(import ../all-custom.nix).pathvisio' ./testit
```

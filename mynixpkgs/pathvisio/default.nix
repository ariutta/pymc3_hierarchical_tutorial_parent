{ callPackage,
organism ? "Homo sapiens",
headless ? false,
genes ? "webservice",
interactions ? false,
metabolites ? "webservice",
# NOTE: this seems high, but I got an error
#       regarding memory when it was lower.
memory ? "2048m"
}:

with builtins;

getAttr organism (callPackage ./all.nix {
  inherit headless genes interactions metabolites memory;
})

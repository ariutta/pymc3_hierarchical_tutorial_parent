{ callPackage,
  organism ? "Homo sapiens", 
  genes ? "webservice",
  interactions ? false,
  metabolites ? "webservice",
  # NOTE: this seems high, but I got an error
  #       regarding memory when it was lower.
  memory ? "2048m"
}:

with builtins;

callPackage ./default.nix {
  inherit organism genes interactions metabolites memory;
  headless = true;
}

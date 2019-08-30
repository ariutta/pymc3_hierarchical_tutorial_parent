{ callPackage,
  organism ? "Homo sapiens",
  headless ? false
}:

with builtins;

callPackage ./default.nix {
  inherit organism headless;
  genes = "local";
  interactions = "local";
  metabolites = "local";
}

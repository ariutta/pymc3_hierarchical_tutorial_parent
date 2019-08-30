{ callPackage,
fetchzip,
headless,
genes,
interactions,
metabolites,
memory
}:

with builtins;

let
  datasourcesLocal = callPackage ./datasourcesLocal.nix {};
  organisms = filter (n:
    let attrN = getAttr n datasourcesLocal;
    in typeOf attrN == "set" && hasAttr "type" attrN && (getAttr "type" attrN) == "genes") (attrNames datasourcesLocal);
in
  listToAttrs (map (organism: 
    let
      geneDatasource = getAttr organism datasourcesLocal;
    in
    {
      name = organism;
      value = callPackage ./common.nix {
        inherit headless memory organism;
        datasources = []
        ++ (if genes == "local" then [{
          src = (getAttr organism datasourcesLocal).src;
          linkCmd = ''
            if grep -Fq "DB_CONNECTSTRING_GDB" "\$PREFS_FILE"
            then
              # code if found
              sed -i.bak 's#DB_CONNECTSTRING_GDB=idmapper-pgdb\\\\:.*\$#DB_CONNECTSTRING_GDB=idmapper-pgdb\\\\:${geneDatasource.src.outPath}/${geneDatasource.src.name}.bridge#' "\$PREFS_FILE"
            else
              # code if not found
              echo 'DB_CONNECTSTRING_GDB=idmapper-pgdb\\:${geneDatasource.src.outPath}/${geneDatasource.src.name}.bridge' >> "\$PREFS_FILE"
            fi
          '';
        }] else [])
        ++ (if interactions == "local" then [{
          src = datasourcesLocal.interactions.src;
          linkCmd = ''
            if grep -Fq "DB_CONNECTSTRING_IDB" "\$PREFS_FILE"
            then
              # code if found
              sed -i.bak 's#DB_CONNECTSTRING_IDB=idmapper-pgdb\\\\:.*\$#DB_CONNECTSTRING_IDB=idmapper-pgdb\\\\:${datasourcesLocal.interactions.src.outPath}/${datasourcesLocal.interactions.src.name}.bridge#' "\$PREFS_FILE"
            else
              # code if not found
              echo 'DB_CONNECTSTRING_IDB=idmapper-pgdb\\:${datasourcesLocal.interactions.src.outPath}/${datasourcesLocal.interactions.src.name}.bridge' >> "\$PREFS_FILE"
            fi
          '';
        }] else [])
        ++ (if metabolites == "local" then [{
          src = datasourcesLocal.metabolites.src;
          linkCmd = ''
            if grep -Fq "DB_CONNECTSTRING_METADB" "\$PREFS_FILE"
            then
              # code if found
              sed -i.bak 's#DB_CONNECTSTRING_METADB=idmapper-pgdb\\\\:.*\$#DB_CONNECTSTRING_METADB=idmapper-pgdb\\\\:${datasourcesLocal.metabolites.src.outPath}/${datasourcesLocal.metabolites.src.name}.bridge#' "\$PREFS_FILE"
            else
              # code if not found
              echo 'DB_CONNECTSTRING_METADB=idmapper-pgdb\\:${datasourcesLocal.metabolites.src.outPath}/${datasourcesLocal.metabolites.src.name}.bridge' >> "\$PREFS_FILE"
            fi
          '';
        }] else []);
      };
    }
  ) organisms)

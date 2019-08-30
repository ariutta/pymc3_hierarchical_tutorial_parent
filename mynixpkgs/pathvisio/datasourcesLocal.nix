{ stdenv, fetchzip }:

# WARNING: some of these are very large!

with builtins;

let
  ensemblRelease = "91";
  ensemblFungiRelease = "39";
  ensemblMetazoaRelease = ensemblFungiRelease;
  ensemblPlantRelease = ensemblFungiRelease;
in
{
  ########
  # genes
  ########

  "Anopheles gambiae" = {
    type = "genes";
    src = fetchzip rec {
      name = "Ag_Derby_Ensembl_Metazoa_${ensemblMetazoaRelease}";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "0bp1p8pq60l369lm3zm3arb3bwmwzm364cf7i7238jkjm1cr2sdn";
    };
  };

  "Arabidopsis thaliana" = {
    type = "genes";
    src = fetchzip rec {
      name = "At_Derby_Ensembl_Plant_${ensemblPlantRelease}";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "06mafr8afasn3nngqqk0daay646dplmvvikw6wp0dc453kgcnihf";
    };
  };

  "Aspergillus niger" = {
    type = "genes";
    src = fetchzip rec {
      name = "An_Derby_Ensembl_Fungi_${ensemblFungiRelease}";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "0i1xs4sw2lsilq3l7fhwdyab2rp76jkgrxhscq5lbjakcqif6f6m";
    };
  };

  "Bacillus subtilis" = {
    type = "genes";
    src = fetchzip rec {
      name = "Bs_Derby_Ensembl_${ensemblRelease}";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "0cjh5nkx8gb3hcypwm82wc4q0jcq0b2lp4gy70fsmyrgfk0x65d8";
    };
  };

  "Bos taurus" = {
    type = "genes";
    src = fetchzip rec {
      name = "Bt_Derby_Ensembl_${ensemblRelease}";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "0gkp6mmz7s28ly0fnh7z35l16192l18mbgxsl8fjp69rwcdp18r5";
    };
  };

  "Caenorhabditis elegans" = {
    type = "genes";
    src = fetchzip rec {
      name = "Ce_Derby_Ensembl_${ensemblRelease}";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "1y5iyw4mpx9ai6p1mj3c97bj0zc6siipi7rq91wzhfcas6vd94r5";
    };
  };

  "Canis familiaris" = {
    type = "genes";
    src = fetchzip rec {
      name = "Cf_Derby_Ensembl_${ensemblRelease}";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "1zglbzch4dpr3bc46y6ljk0w1iajj23i92pd80i0fk0wcv52dv58";
    };
  };

  "Ciona intestinalis" = {
    type = "genes";
    src = fetchzip rec {
      name = "Ci_Derby_Ensembl_${ensemblRelease}";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "0mhzh1jhf4fpyixbf8250adwxar8iah3ij27jjc9blxbwypwxci4";
    };
  };

  "Danio rerio" = {
    type = "genes";
    src = fetchzip rec {
      name = "Dr_Derby_Ensembl_${ensemblRelease}";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "15q27qal6pkpigr8ih4q3x2hmqdlm7r2j198ycachrlpn5yibima";
    };
  };

  "Drosophila melanogaster" = {
    type = "genes";
    src = fetchzip rec {
      name = "Dm_Derby_Ensembl_${ensemblRelease}";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "0a20z1bnpvfvclkpxs6hi63sylrc4n9mnvfg8hganr5w99zcz4fz";
    };
  };

  "Escherichia coli" = {
    type = "genes";
    src = fetchzip rec {
      name = "Ec_Derby_Ensembl_${ensemblRelease}";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "1dw4233dlwwixaq53kzva3zs0hsa4fd5zgh2j186mbd840p3lpmh";
    };
  };

  "Gallus gallus" = {
    type = "genes";
    src = fetchzip rec {
      name = "Gg_Derby_Ensembl_${ensemblRelease}";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "10h9b0lbqw1pljvp200svind6hprg3gabiw90k4z5dkbnbj1qbaj";
    };
  };

  "Glycine max" = {
    type = "genes";
    src = fetchzip rec {
      name = "Gm_Derby_Ensembl_Plant_${ensemblPlantRelease}";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "1q6xkxxavaf51nakhh8b3wnsg68m6ah542ishy0m1r4hwkmhqihk";
    };
  };

  "Gibberella zeae" = {
    type = "genes";
    src = fetchzip rec {
      name = "Gz_Derby_Ensembl_Fungi_${ensemblFungiRelease}";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "0f0ffpn2cwiwi51i8bfj23v7166v430q3ln29nfw0gb86f60kps3";
    };
  };

  "Homo sapiens" = {
    type = "genes";
    src = fetchzip rec {
      name = "Hs_Derby_Ensembl_${ensemblRelease}";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "0y1fw0sz9s37m5wgxgrrqff5gbnrpbkl0i0wcyqhq29c3ygk0pv4";
    };
  };

  "Hordeum vulgare" = {
    type = "genes";
    src = fetchzip rec {
      name = "Hv_Derby_Ensembl_Plant_${ensemblPlantRelease}";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "0vi9h2fvrndkk9070f2ggid183gbhqz6c9il41d7247xx4i5v2as";
    };
  };

  "Macaca mulatta" = {
    type = "genes";
    src = fetchzip rec {
      name = "Ml_Derby_Ensembl_${ensemblRelease}";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "0x4hr0i08y0kygr9g488i608qawkhaybhjkmgd74xmwxnv2xxrd3";
    };
  };

  "Mus musculus" = {
    type = "genes";
    src = fetchzip rec {
      name = "Mm_Derby_Ensembl_${ensemblRelease}";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "0arqb3bmiincrpkdvrrw2mbp7ydqw5bys8rrgkj7i0zpd7lxbbf3";
    };
  };

  "Mycobacterium tuberculosis" = {
    type = "genes";
    src = fetchzip rec {
      name = "Mx_Derby_Ensembl_${ensemblRelease}";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "0ccw8lxhn4vdzncdrpanmq5m9hmpyjvfav2z377bj3jj6s0yrbwz";
    };
  };

  # TODO add the other gene databases.
  # http://bridgedb.org/data/gene_database/
  #
  # The supported organisms are listed here:
  # https://github.com/bridgedb/BridgeDb/blob/master/org.bridgedb.bio/resources/org/bridgedb/bio/organisms.txt
  # 
  # TODO: This should work to get the sha256, but its result differs from that gotten during an installation:
  # nix-prefetch-url --unpack http://bridgedb.org/data/gene_database/An_Derby_Ensembl_Fungi_39.bridge.zip
  # I also tried specifying --type sha256 but got the same incorrect hash.

  ################
  # not genes
  ################

  interactions = {
    type = "interactions";
    src = fetchzip rec {
      name = "interactions_20180425";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "1mvb3jh3slwc35xw6iiygjld0d6xjmhs786r5srac3wnnfa34hl5";
    };
  };

  metabolites = {
    type = "metabolites";
    src = fetchzip rec {
      name = "metabolites_20180508";
      url = "http://bridgedb.org/data/gene_database/${name}.bridge.zip";
      sha256 = "0prfvm7c91rc1hhp1nwz0l2s2z4d7g8rccdr64amqhq4v2f8bbp4";
    };
  };
}

{ pkgs, callPackage }:

let
  # TODO specifying Black in buildInputs, propagatedBuildInputs, etc.
  # doesn't put it on the PATH. (I think I tried all of the options.)
  # More info: https://nixos.org/nixpkgs/manual/#ssec-stdenv-dependencies
  # See also: https://github.com/NixOS/nixpkgs/issues/26146
  #
  # But Black needs to be on the PATH to work with Neoformat.
  # Options:
  # 1. Have Black run "inside the Vim process directly", not via Neoformat/CLI.
  #    (See https://github.com/ambv/black#vim)
  #    The docs say it runs faster this way. But would that work with Nix? The
  #    docs also say, "On first run, the plugin creates its own virtualenv using
  #    the right Python version and automatically installs Black."
  # 2. Specify Black as a dependency in ../../common.nix
  #    For now, I'm using a hack by specifying custom.black in common.nix,
  #    but I should be able to specify all my Vim deps in here.
  # 3. Add Black to the vim runtimepath (rtp), which appears to be basically
  #    the PATH variable that applies for anything running inside vim.
  vimCustomBuildInputs = import ./buildInputs.nix; 
  CUSTOM_PATH = builtins.unsafeDiscardStringContext (builtins.concatStringsSep ":" (builtins.map (b: builtins.toString (b.outPath) + "/bin") vimCustomBuildInputs));
  POWER_LINE_VIM_PATH = builtins.unsafeDiscardStringContext (pkgs.python3Packages.powerline.outPath + "/lib/python3.*/site-packages/powerline/bindings/vim");
  PYLS_PATH = builtins.unsafeDiscardStringContext (pkgs.python3Packages.python-language-server.outPath + "/bin");

  vim_configurable = pkgs.vim_configurable.override { python=pkgs.python3; };

  vim_configured = vim_configurable.overrideAttrs (oldAttrs: {
    # NOTE: we don't need to specify the following:
    #   with import <nixpkgs> { config.vim.ftNix = false; };
    # because we specify the same thing here:
    ftNixSupport = false;
    buildInputs = vim_configurable.buildInputs ++ [
      ####################
      # Deps for powerline
      ####################
      # TODO does the powerline package automatically install the powerline fonts?
      #pkgs.powerline-fonts
      # NOTE: the PyPi name is powerline-status, but the Nix name is just powerline.
      pkgs.python3Packages.powerline
    ] ++ vimCustomBuildInputs;
  });

in

vim_configured.customize {
    name = "vim";
    vimrcConfig.customRC = builtins.replaceStrings [
      "CUSTOM_PATH_REPLACE_ME" "POWER_LINE_VIM_PATH_REPLACE_ME" "PYLS_PATH_REPLACE_ME"
    ] [CUSTOM_PATH POWER_LINE_VIM_PATH PYLS_PATH] (builtins.readFile ./.vimrc);

    # Use the default plugin list shipped with nixpkgs
    vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
    vimrcConfig.vam.pluginDictionaries = [

      { names = [
        # Here you can place all your vim plugins
        # They are installed managed by `vam` (a vim plugin manager)
        # Lookup names here:
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/misc/vim-plugins/default.nix
        # and here: http://vam.mawercer.de/

        # Low-blue light color scheme
        # https://github.com/morhetz/gruvbox
        # https://github.com/morhetz/gruvbox-contrib
        # https://blog.jeaye.com/2018/02/01/gruvbox/
        "gruvbox"

        # make vim syntax aware
        #"Syntastic"
        "ale"
        # syntax providers (see dependencies in vim_configured.buildInputs)
        # NOTE: it appears necessary to put these here, because when I
        # try putting them in the "JavaScript/TypeScript-only" section,
        # things don't work correctly.
        "typescript-vim"
        "vim-javascript"
        "vim-jsdoc"
        # provides nix syntax highlighting, filetype detection and indentation.
        # NOTE: using vim-nix instead of this: { config.vim.ftNix = true; }
        "vim-nix"

        # format code (see dependencies in vim_configured.buildInputs)
        "neoformat"

        # autocomplete
        "YouCompleteMe"
        "LanguageClient-neovim"

        # automatic closing of quotes, parenthesis, brackets, etc.
        # https://github.com/jiangmiao/auto-pairs
        "auto-pairs"

        # type "ysiw]" to surround w/ brackets
        "surround"

        # ctrlp makes it easier to open files, buffers, etc.
        # Call it with :CtrlPMixed or Ctrl+p
        "ctrlp"
        # This C extension speeds up ctrlp's finder
        "ctrlp-cmatcher"

        # git wrapper
        #   For screencasts on how to use:
        #     https://github.com/tpope/vim-fugitive#screencasts
        #   To compare a file across branches:
        #     Gedit master:myfile.txt
        #     Gdiff dev:myfile.txt
        "fugitive"

        # Handle delimited files (.csv, .tsv, etc.)
        #   http://vimawesome.com/plugin/csv-vim
        #   If a file is .txt, tell vim it's delimited with:
        #     :set filetype=csv
        "csv"

        # comment / uncomment
        #   https://github.com/tpope/vim-commentary
        #   comment: gc in visual mode
        #   uncomment: gcgc on a commented section
        "vim-commentary"
      ]; }

      # Load for JavaScript/TypeScript
      { names =  [

        # provides typescript autocomplete, error checking and more.
        "tsuquyomi"
        ]; ft_regex = "^typescript\$"; }

    ];
}

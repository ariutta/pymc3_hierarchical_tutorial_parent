{
bashInteractive,
fetchFromGitHub,
gawk,
stdenv,
enabledAliases ? [],
enabledCompletions ? [ "bash-it" "git" "npm" "ssh" "tmux" ],
enabledPlugins ? [] }:

with builtins;

let
  baseName = "bash-it";
  version = "4a64dcb";
in
stdenv.mkDerivation rec {
  name = (concatStringsSep "-" [baseName version]);

  # nativeBuildInputs shouldn't persist as run-time dependencies.
  #   From the manual:
  #   "Since these packages are able to be run at build time, that are added to
  #    the PATH, as described above. But since these packages only are
  #    guaranteed to be able to run then, they shouldn't persist as run-time
  #    dependencies. This isn't currently enforced, but could be in the future."
  nativeBuildInputs = [ gawk ];

  # buildInputs may be used at run-time but are only on the PATH at build-time.
  #   From the manual:
  #   "These often are programs/libraries used by the new derivation at
  #    run-time, but that isn't always the case."
  buildInputs = [ ];

  awkAlias = "${gawk}/bin/awk";

  src = fetchFromGitHub {
    owner = "Bash-it";
    repo = "bash-it";
    rev = "4a64dcbc6f15b9b2cd3883a96f81bc94a5a0fe24";
    sha256 = "1zzi4iwznqsdy7kzkqh9clhvqlzh3bym1cfr1fhg701bnnnx8z0x";
  };

  awkPattern = "[`(|[:space:]]awk[[:space:]]";

  buildPhase = ''
    patchShebangs ./install.sh

    #substituteInPlace bash_it.sh --replace "/usr/bin/env bash" "${bashInteractive}/bin/bash"
  '';

  doCheck = true;

  checkPhase = ''
    if [ ! -e "./bash_it.sh" ]; then
      echo "test failed: bash_it.sh does not exist"
      exit 1;
    fi

    ${bashInteractive}/bin/bash -c 'export BASH_IT="./"; . bash_it.sh; bash-it --help > /dev/null'
  '';

  enabledAliasesStr = concatStringsSep " " (filter (x: isString x) enabledAliases);
  enabledCompletionsStr = concatStringsSep " " (filter (x: isString x) enabledCompletions);
  enabledPluginsStr = concatStringsSep " " (filter (x: isString x) enabledPlugins);

  # TODO: when I run "sudo nixos-rebuild switch", I get the error below, most
  # likely because whatever is doing the reload isn't using interactive bash.
  # I tried patching these files in the installPhase, but I'm still getting the same error.
  # I also tried patching bash_it.sh in the buildPhase. Still same error.
  #
  # reloading user units for ariutta...
  # /home/ariutta/.nix-profile/share/bash_it/enabled/350---bash-it.completion.bash: line 121: complete: command not found
  # /home/ariutta/.nix-profile/share/bash_it/enabled/350---bash-it.completion.bash: line 122: complete: command not found
  # /home/ariutta/.nix-profile/share/bash_it/enabled/350---bash-it.completion.bash: line 123: complete: command not found
  # /home/ariutta/.nix-profile/share/bash_it/enabled/350---bash-it.completion.bash: line 124: complete: command not found
  # /home/ariutta/.nix-profile/share/bash_it/enabled/350---bash-it.completion.bash: line 125: complete: command not found
  # /home/ariutta/.nix-profile/share/bash_it/enabled/350---bash-it.completion.bash: line 126: complete: command not found
  # /home/ariutta/.nix-profile/share/bash_it/enabled/350---git.completion.bash: line 2752: complete: command not found
  # /home/ariutta/.nix-profile/share/bash_it/enabled/350---git.completion.bash: line 2752: complete: command not found
  # /home/ariutta/.nix-profile/share/bash_it/enabled/350---ssh.completion.bash: line 40: complete: command not found
  # /home/ariutta/.nix-profile/share/bash_it/enabled/350---tmux.completion.bash: line 185: complete: command not found
  # /home/ariutta/.nix-profile/share/bash_it/enabled/350---bash-it.completion.bash: line 121: complete: command not found
  # /home/ariutta/.nix-profile/share/bash_it/enabled/350---bash-it.completion.bash: line 122: complete: command not found
  # /home/ariutta/.nix-profile/share/bash_it/enabled/350---bash-it.completion.bash: line 123: complete: command not found
  # /home/ariutta/.nix-profile/share/bash_it/enabled/350---bash-it.completion.bash: line 124: complete: command not found
  # /home/ariutta/.nix-profile/share/bash_it/enabled/350---bash-it.completion.bash: line 125: complete: command not found
  # /home/ariutta/.nix-profile/share/bash_it/enabled/350---bash-it.completion.bash: line 126: complete: command not found
  # /home/ariutta/.nix-profile/share/bash_it/enabled/350---git.completion.bash: line 2752: complete: command not found
  # /home/ariutta/.nix-profile/share/bash_it/enabled/350---git.completion.bash: line 2752: complete: command not found
  # /home/ariutta/.nix-profile/share/bash_it/enabled/350---ssh.completion.bash: line 40: complete: command not found
  # /home/ariutta/.nix-profile/share/bash_it/enabled/350---tmux.completion.bash: line 185: complete: command not found

  installPhase = ''
    targetDir="$out/share/bash_it"
    mkdir -p $targetDir

    for content in aliases bash_it.sh completion custom install.sh lib plugins template themes uninstall.sh
    do
      cp -r "$content" "$targetDir/$content"
    done

    for f in $(grep -rIl '${awkPattern}' "$targetDir"); do
      substituteInPlace $f \
            --replace "awk" "${awkAlias}"
    done

    ./install.sh --no-modify-config

    # Installing the specific completions specified.
    # We're using bashInteractive because bash-it needs the compgen tool,
    # and non-interactive bash doesn't have it.
    (${bashInteractive}/bin/bash -c 'export BASH_IT="$out/share/bash_it"; cd "$BASH_IT"; . bash_it.sh; bash-it enable alias ${enabledAliasesStr}')
    (${bashInteractive}/bin/bash -c 'export BASH_IT="$out/share/bash_it"; cd "$BASH_IT"; . bash_it.sh; bash-it enable completion ${enabledCompletionsStr}')
    (${bashInteractive}/bin/bash -c 'export BASH_IT="$out/share/bash_it"; cd "$BASH_IT"; . bash_it.sh; bash-it enable plugin ${enabledPluginsStr}')

#    for f in $out/share/bash_it/enabled/350*.completion.bash
#    do
#      # Note: some of these files start with shebangs but some do not
#      sed -i '1s_^_#!${bashInteractive}/bin/bash\n_' "$f"
#    done
  '';

  postFixup = ''
    # TODO: could (at least some of) the powerline content be moved into its own Nix package?
    echo ""
    echo "****************************************"
    echo "* Add the following to your ~/.profile *"
    echo "****************************************"
    echo ""
    echo "export BASH_IT=\"\$HOME/.nix-profile/share/bash_it\""
    echo 'if [ -n "$BASH_VERSION" ] && [ -d "$BASH_IT" ]; then'
    echo '    # Assume Bash'
    echo ""
    echo '    export PATH=$PATH:$BASH_IT'
    echo ""
    echo '    POWERLINE_PATH="$(nix-env -q --out-path --no-name python3.*-powerline.* | head -n 1)/lib/python3.*/site-packages/powerline/bindings/bash/powerline.sh"'
    echo '    if [ -f $POWERLINE_PATH ]; then'
    echo '        # http://powerline.readthedocs.io/en/master/usage/shell-prompts.html#bash-prompt'
    echo '        powerline-daemon -q'
    echo '        export POWERLINE_BASH_CONTINUATION=1'
    echo '        export POWERLINE_BASH_SELECT=1'
    echo '        . "$POWERLINE_PATH"'
    echo ""
    echo '        # Lock and Load a custom theme file'
    echo '        # location $HOME/.bash_it/themes/'
    echo '        export BASH_IT_THEME="powerline"'
    echo '    fi'
    echo ""
    echo '    # Load Bash It'
    echo '    if [ -e "$BASH_IT/bash_it.sh" ]; then . "$BASH_IT/bash_it.sh"; fi'
    echo 'fi'
    echo ""
  '';

  meta = with stdenv.lib;
    { description = "A community Bash framework";
      longDescription = ''
	Bash-it is a collection of community Bash commands and scripts for Bash 3.2+. (And a shameless ripoff of oh-my-zsh 😃)

	Includes autocompletion, themes, aliases, custom functions, a few stolen pieces from Steve Losh, and more.
      '';
      homepage = https://github.com/Bash-it/bash-it;
      #license = licenses.asl20;
      maintainers = with maintainers; [ ariutta ];
      platforms = platforms.all;
    };
}

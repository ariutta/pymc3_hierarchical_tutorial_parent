The file override.nix is supposed to add the mediawiki ruleset, but it's giving write permission errors.
So for now, we're forced to call phpcs and phpcbf with an argument specifying the path to the standard:
```
phpcbf --standard="$(nix-env -q --out-path --no-name 'composer-mediawiki-mediawiki-codesniffer')/share/php/composer-mediawiki-mediawiki-codesniffer/vendor/mediawiki/mediawiki-codesniffer/MediaWiki/ruleset.xml" ../../wow.php
```

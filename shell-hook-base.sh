#!/usr/bin/env bash

# Workaround for the following issue:
# https://github.com/NixOS/nixpkgs/issues/45463#issuecomment-477198263
TMP="/tmp/$(id -u)"
export TMP="$TMP"
export TMPDIR="$TMP"
export TEMP="$TMP"
export TEMPDIR="$TMP"

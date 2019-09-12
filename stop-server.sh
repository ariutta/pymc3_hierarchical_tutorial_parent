#!/usr/bin/env bash

# TODO: this assumes ./start-server.sh will always use the same port
PORT="8888"

jupyter notebook stop "$PORT"

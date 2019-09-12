#!/usr/bin/env bash

PORT="8888"

jupyter notebook --no-browser --port="$PORT" --notebook-dir ./pymc3_hierarchical_tutorial

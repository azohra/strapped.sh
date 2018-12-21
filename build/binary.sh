#!/bin/bash

# Copy components and put them into final file
cat src/helpers.sh > strapped
cat src/cli.sh >> strapped
cat src/main.sh >> strapped

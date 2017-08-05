#!/usr/bin/env bash

# Create Development Folders
mkdir -p ~/dev
mkdir -p ~/dev/certs
mkdir -p ~/dev/envs
mkdir -p ~/dev/docker
mkdir -p ~/dev/learning
mkdir -p ~/dev/lib
mkdir -p ~/dev/projects
mkdir -p ~/dev/reference
mkdir -p ~/dev/sandbox
mkdir -p ~/dev/scratch
mkdir -p ~/dev/tmp
mkdir -p ~/dev/tools

# Create Symbolic Links
if [ ! -d ~/dev/bin ]; then
    ln -s ~/dev/shell/bin ~/dev/
fi

if [ ! -f ~/.bash_profile ]; then
    ln -s ~/dev/shell/home/bash_profile ~/.bash_profile
fi

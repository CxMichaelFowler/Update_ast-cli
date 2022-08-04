#!/bin/bash

# Set the repo for the AST CLI
repo=Checkmarx/ast-cli

# Set the location of cx
home_dir=$HOME/ast-cli
cd $home_dir

# Get the current version of the CLI
current_version=$(./cx version 2>/dev/null)

releases=https://api.github.com/repos/$repo/releases/latest
tag=$(curl $releases | grep tag_name | sed 's/[^:]*: "\([^"]*\)".*/\1/')

if [[ "$tag" > "$current_version" ]]
then
    # Download latest version
    file=ast-cli_${tag}_linux_x64.tar.gz
    download=https://github.com/$repo/releases/download/$tag/$file
    curl -L -o $file $download
    tar zxf $file
    rm $file
fi

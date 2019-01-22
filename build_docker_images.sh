#!/bin/bash

set -x
set -e

# build all docker images
if [ ! -z $1 ]
then
    for dir in base yosys;
    do
        (cd $dir && docker build -t ${dir}:latest .)
    done

    for dir in riscv-tools verilator;
    do
        pwd
        cd $dir
        pwd
        for version_dir in `find . -mindepth 1 -maxdepth 1 -type d -printf '%f\n'`;
        do
            (cd $version_dir && pwd && docker build -t ${dir}:${version_dir} .)
        done
        cd ..
    done

    pwd
    cd images
    pwd
    for dir in `find . -mindepth 1 -maxdepth 1 -type d -printf '%f\n'`;
    do
        (cd $dir && pwd && docker build -t ucbbar/riscv-docker-images:${dir}-$1 .)
    done
else
    echo "No build done. No version tag for the images was given."
fi

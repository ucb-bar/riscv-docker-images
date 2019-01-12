RISC-V Docker Images
====================

This is a curated set of DockerFiles used to install riscv-tools and verilator versions. You can find the docker containers
created in this repository at https://hub.docker.com/r/ucbbar/riscv-docker-images.

Repository Organization
-----------------------

This repository is split into multiple directories which build a particular tool/item. The `base`
directory holds a `DockerFile` that setups the user, builds **SBT**, and installs any apt packages needed for subsequent builds.
The `riscv-tools` directory contains folders labeled with a *commit hash*. The `DockerFile` within these directories build
a specific version of **riscv-tools**. Similarly, the `verilator` directory has subdirectories labeled with a version of 
**Verilator** that they build. the `yosys` directory is similar to base in which there is only one `DockerFile` that specifies
the version of *Yosys* to build. Finally, the `images` directory combines all these separate docker builds and creates a final
image with **SBT**, **riscv-tools**, **Verilator**, and **Yosys**. The subdirectories within `images` are labeled with the **riscv-tools**
hash and version of **Verilator** that they use. In summary the directory heirarchy is as follows:

- `base` - top level docker image
- `yosys` - build yosys docker image
- `riscv-tools` - build various versions of riscv-tools docker images
    - `RISCVTOOLS_VERSION_HASH`
- `verilator` - build various versions of verilator
    - `VERILATOR_VERSION_NUMBER`
- `images` - build various combinations of the above tools/items
    - `RISCVTOOLS_VERSION_HASH-VERILATOR_VERSION_NUMBER`

How to build
------------

In order to build, run the following command:

```
sudo build_docker_images.sh TAG_NUMBER
```

This will build **all** the docker images in the repository as well as create an updated version of final docker images (the ones 
in `images`) with the `TAG_NUMBER` specified. The final images created out of this command will be labeled as
`ucbbar/riscv-docker-images:ROCKETCHIP_VERSION_HASH-VERILATOR_VERSION_NUMBER-TAG_NUMBER`

More tools...
-------------

If you would like to have a particular set of tools (updated riscv-tools, verilator, etc...) added to the curated repository and
DockerHub, please make an GitHub issue. Thanks!

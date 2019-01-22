ARG YosysVersions="yosys-0.7"
ARG YosysRoot=/opt/yosys
FROM base:latest
ARG YosysVersions
ARG YosysRoot
USER root
WORKDIR /tmp/build

RUN git clone https://github.com/cliffordwolf/yosys.git

# Replace the version of ABC used by yosys with the version we recommend
#  for the formal verification tests.
COPY fix_yosys_abc.patch fix_yosys_abc.patch

# Build Yosys
RUN \
  cd yosys && \
  echo $YosysVersions && \
  for v in $YosysVersions ; do \
    echo $v && \
    git checkout $v && \
    git clean -fdx && \
    git apply ../fix_yosys_abc.patch && \
    make CONFIG=gcc && \
    make CONFIG=gcc PREFIX=$YosysRoot install clean;\
  done

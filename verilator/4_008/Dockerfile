FROM base:latest

# Install verilator
RUN git clone http://git.veripool.org/git/verilator /tmp/verilator \
    && cd /tmp/verilator \
    && git pull \
    && git checkout verilator_4_008 \
    && unset VERILATOR_ROOT \
    && autoconf \
    && ./configure \
    && make \
    && make install \
    && rm -rf /tmp/verilator

ENV INSTALLED_VERILATOR="/usr/local/bin/verilator"

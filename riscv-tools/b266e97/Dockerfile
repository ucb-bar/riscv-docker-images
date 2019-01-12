FROM base:latest

# Update RISCV/PATH vars for RISCV toolchain
ENV RISCV="/usr/bin/riscv-tools"
ENV PATH="$RISCV/bin:$PATH"

# Install riscv-tools
RUN git clone https://github.com/riscv/riscv-tools.git /tmp/riscv-tools\
    && cd /tmp/riscv-tools \
    && git checkout b266e97760fbe57feee534941f890d0cde14245a \
    && git submodule update --init --recursive \
    && ./build.sh \
    && rm -rf /tmp/riscv-tools

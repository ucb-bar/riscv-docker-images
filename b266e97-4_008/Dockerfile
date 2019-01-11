FROM openjdk:11.0.1-jdk

# man directory is missing in some base images
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=863199
RUN apt-get update \
    && mkdir -p /usr/share/man/man1 \
    && apt-get install -y \
               apt-transport-https \
               bzip2 \
               ca-certificates \
               curl \
               git \
               gnupg \
               gzip \
               locales \
               mercurial \
               netcat \
               net-tools \
               openssh-client \
               parallel \
               sudo \
               tar \
               unzip \
               wget \
               xvfb \
               zip

# Set timezone to UTC by default
RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

# Use unicode
RUN locale-gen C.UTF-8 || true
ENV LANG=C.UTF-8

# Add riscvuser
RUN groupadd --gid 3434 riscvuser \
    && useradd --uid 3434 --gid riscvuser --shell /bin/bash --create-home riscvuser \
    && echo 'riscvuser ALL=NOPASSWD: ALL' >> /etc/sudoers.d/50-riscvuser \
    && echo 'Defaults    env_keep += "DEBIAN_FRONTEND"' >> /etc/sudoers.d/env_keep

# Install Maven Version: 3.6.0
RUN curl --silent --show-error --location --fail --retry 3 --output /tmp/apache-maven.tar.gz https://www.apache.org/dist/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz   && tar xf /tmp/apache-maven.tar.gz -C /opt/   && rm /tmp/apache-maven.tar.gz   && ln -s /opt/apache-maven-* /opt/apache-maven   && /opt/apache-maven/bin/mvn -version

# Install Ant Version: 1.10.5
RUN curl --silent --show-error --location --fail --retry 3 --output /tmp/apache-ant.tar.gz https://archive.apache.org/dist/ant/binaries/apache-ant-1.10.5-bin.tar.gz   && tar xf /tmp/apache-ant.tar.gz -C /opt/   && ln -s /opt/apache-ant-* /opt/apache-ant   && rm -rf /tmp/apache-ant.tar.gz   && /opt/apache-ant/bin/ant -version

ENV ANT_HOME=/opt/apache-ant

# Install Gradle Version: 5.0
RUN curl --silent --show-error --location --fail --retry 3 --output /tmp/gradle.zip https://services.gradle.org/distributions/gradle-5.0-bin.zip   && unzip -d /opt /tmp/gradle.zip   && rm /tmp/gradle.zip   && ln -s /opt/gradle-* /opt/gradle   && /opt/gradle/bin/gradle -version

# Install sbt
RUN echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list \
    && sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 \
    && sudo apt-get update \
    && sudo apt-get install sbt

# Install openjfx
RUN apt-get install -y --no-install-recommends openjfx

# Add RISCV toolchain necessary dependencies
RUN apt-get install -y \
            autoconf \
            automake \
            autotools-dev \
            babeltrace \
            bc \
            bison \
            build-essential \
            curl \
            device-tree-compiler \
            expat \
            flex \
            gawk \
            gperf \
            libexpat-dev \
            libgmp-dev \
            libmpc-dev \
            libmpfr-dev \
            libtool \
            libusb-1.0-0-dev \
            patchutils \
            pkg-config \
            python \
            python-pexpect \
            texinfo \
            zlib1g-dev

# Update PATH for Java tools
ENV PATH="/opt/sbt/bin:/opt/apache-maven/bin:/opt/apache-ant/bin:/opt/gradle/bin:$PATH"

# Update RISCV/PATH vars for RISCV toolchain
ENV RISCV="/usr/bin/riscv-tools"
ENV PATH="$RISCV/bin:$PATH"

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

# Install riscv-tools
RUN git clone https://github.com/riscv/riscv-tools.git /tmp/riscv-tools\
    && cd /tmp/riscv-tools \
    && git submodule update --init --recursive \
    && ./build.sh \
    && rm -rf /tmp/riscv-tools

# smoke test with path
RUN mvn -version \
    && ant -version \
    && gradle -version \
    && sbt sbtVersion

USER riscvuser 

CMD ["/bin/sh"]

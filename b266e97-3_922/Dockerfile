FROM openjdk:11.0.1-jdk-sid

# make Apt non-interactive
RUN echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90riscvuser \
  && echo 'DPkg::Options "--force-confnew";' >> /etc/apt/apt.conf.d/90riscvuser

ENV DEBIAN_FRONTEND=noninteractive

# man directory is missing in some base images
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=863199
RUN apt-get update \
  && mkdir -p /usr/share/man/man1 \
  && apt-get install -y \ 
    git mercurial xvfb \
    locales sudo openssh-client ca-certificates tar gzip parallel \
    net-tools netcat unzip zip bzip2 gnupg curl wget

# Set timezone to UTC by default
RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

# Use unicode
RUN locale-gen C.UTF-8 || true
ENV LANG=C.UTF-8

# Install Docker

# Docker.com returns the URL of the latest binary when you hit a directory listing
# We curl this URL and `grep` the version out.
# The output looks like this:

#>    # To install, run the following commands as root:
#>    curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-17.05.0-ce.tgz && tar --strip-components=1 -xvzf docker-17.05.0-ce.tgz -C /usr/local/bin
#>
#>    # Then start docker in daemon mode:
#>    /usr/local/bin/dockerd

RUN set -ex \
  && export DOCKER_VERSION=$(curl --silent --fail --retry 3 https://download.docker.com/linux/static/stable/x86_64/ | grep -o -e 'docker-[.0-9]*-ce\.tgz' | sort -r | head -n 1) \
  && DOCKER_URL="https://download.docker.com/linux/static/stable/x86_64/${DOCKER_VERSION}" \
  && echo Docker URL: $DOCKER_URL \
  && curl --silent --show-error --location --fail --retry 3 --output /tmp/docker.tgz "${DOCKER_URL}" \
  && ls -lha /tmp/docker.tgz \
  && tar -xz -C /tmp -f /tmp/docker.tgz \
  && mv /tmp/docker/* /usr/bin \
  && rm -rf /tmp/docker /tmp/docker.tgz \
  && which docker \
  && (docker version || true)

RUN groupadd --gid 3434 riscvuser \
  && useradd --uid 3434 --gid riscvuser --shell /bin/bash --create-home riscvuser \
  && echo 'riscvuser ALL=NOPASSWD: ALL' >> /etc/sudoers.d/50-riscvuser \
  && echo 'Defaults    env_keep += "DEBIAN_FRONTEND"' >> /etc/sudoers.d/env_keep

# BEGIN IMAGE CUSTOMIZATIONS

# Install Maven Version: 3.6.0
RUN curl --silent --show-error --location --fail --retry 3 --output /tmp/apache-maven.tar.gz     https://www.apache.org/dist/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz   && tar xf /tmp/apache-maven.tar.gz -C /opt/   && rm /tmp/apache-maven.tar.gz   && ln -s /opt/apache-maven-* /opt/apache-maven   && /opt/apache-maven/bin/mvn -version

# Install Ant Version: 1.10.5
RUN curl --silent --show-error --location --fail --retry 3 --output /tmp/apache-ant.tar.gz     https://archive.apache.org/dist/ant/binaries/apache-ant-1.10.5-bin.tar.gz   && tar xf /tmp/apache-ant.tar.gz -C /opt/   && ln -s /opt/apache-ant-* /opt/apache-ant   && rm -rf /tmp/apache-ant.tar.gz   && /opt/apache-ant/bin/ant -version

ENV ANT_HOME=/opt/apache-ant

# Install Gradle Version: 5.0
RUN curl --silent --show-error --location --fail --retry 3 --output /tmp/gradle.zip     https://services.gradle.org/distributions/gradle-5.0-bin.zip   && unzip -d /opt /tmp/gradle.zip   && rm /tmp/gradle.zip   && ln -s /opt/gradle-* /opt/gradle   && /opt/gradle/bin/gradle -version

# Install sbt
RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823 \
  && apt-get update \
  && apt-get install sbt

# Install openjfx
RUN apt-get install -y --no-install-recommends openjfx

# Add RISCV toolchain necessary dependencies
RUN apt-get install -y autoconf automake autotools-dev build-essential curl libmpc-dev libmpfr-dev libgmp-dev libusb-1.0-0-dev gawk bison flex texinfo gperf libtool patchutils bc zlib1g-dev device-tree-compiler pkg-config libexpat-dev expat python-pexpect python babeltrace

# Update PATH for Java tools
ENV PATH="/opt/sbt/bin:/opt/apache-maven/bin:/opt/apache-ant/bin:/opt/gradle/bin:$PATH"

# Update RISCV/PATH vars for RISCV toolchain
ENV RISCV="/usr/bin/riscv-tools"
ENV PATH="$RISCV/bin:$PATH"

# Install verilator
RUN git clone http://git.veripool.org/git/verilator /tmp/verilator \
  && cd /tmp/verilator \
  && git pull \
  && git checkout verilator_3_922 \
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
# END IMAGE CUSTOMIZATIONS

USER riscvuser 

CMD ["/bin/sh"]

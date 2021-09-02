# Base image from CentOS 7
FROM centos:7

ARG ZEEK_ROOT=/opt/zeek
ARG DOCKER_ROOT="/opt/docker"
ARG DOCKER_SCRIPTS="$DOCKER_ROOT/scripts"
ARG START_SCRIPT="$DOCKER_ROOT/start.sh"

ENV ZEEK_ROOT "$ZEEK_ROOT"
ENV PATH "$ZEEK_ROOT/bin:$DOCKER_SCRIPTS:$PATH"
ENV START_SCRIPT "$START_SCRIPT"

VOLUME ["/opt/zeek/etc"]
VOLUME ["/opt/zeek/logs"]
VOLUME ["/opt/zeek/spool"]

# Copy start and common script
RUN mkdir -p "$DOCKER_ROOT"
COPY ./start.sh "$DOCKER_ROOT"
COPY ./common.sh "$DOCKER_ROOT"
RUN chmod +x "$DOCKER_ROOT"/*.sh

# Copy command scripts
RUN mkdir -p "$DOCKER_SCRIPTS"
COPY ./scripts "$DOCKER_SCRIPTS"
RUN chmod +x "$DOCKER_SCRIPTS"/*

# Install required packages
RUN yum install -y cmake make gcc gcc-c++ flex bison libpcap-devel \
    openssl-devel python3 python3-devel swig zlib-devel wget net-tools git

# Install Zeek
RUN cd /etc/yum.repos.d/ && \
    wget https://download.opensuse.org/repositories/security:zeek/CentOS_7/security:zeek.repo && \
    yum install -y zeek

# Install Zeek Package Manager
RUN pip3 install GitPython semantic-version

CMD $START_SCRIPT
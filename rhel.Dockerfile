# Copyright (c) 2021 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#

# https://access.redhat.com/containers/?tab=tags#/registry.access.redhat.com/ubi8-minimal
FROM registry.access.redhat.com/ubi8-minimal:8.4-200

ARG KUBERNETES_VERSION=1.21.1
ARG REST_SERVER_VERSION=0.10.0

RUN export ARCH="$(uname -m)" && \
    if [[ ${ARCH} == "x86_64" ]]; then export ARCH="amd64"; \
    elif [[ ${ARCH} == "aarch64" ]]; then export ARCH="arm64"; \
    fi && \
    microdnf install -y openssl tar gzip && \
    cd /usr/local/bin && \
    curl -sLO https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/${ARCH}/kubectl && \
    chmod +x kubectl && \
    cd /tmp && \
    curl -sLO https://github.com/restic/rest-server/releases/download/v${REST_SERVER_VERSION}/rest-server_${REST_SERVER_VERSION}_linux_${ARCH}.tar.gz && \
    tar -xzf rest-server_${REST_SERVER_VERSION}_linux_${ARCH}.tar.gz && \
    cp rest-server_${REST_SERVER_VERSION}_linux_${ARCH}/rest-server /usr/local/bin/rest-server && \
    rm -rf rest-server_${REST_SERVER_VERSION}_linux_${ARCH} rest-server_${REST_SERVER_VERSION}_linux_${ARCH}.tar.gz && \
    microdnf remove -y tar gzip && \
    microdnf clean all

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

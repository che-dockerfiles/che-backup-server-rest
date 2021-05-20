# Copyright (c) 2021 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#

FROM alpine:3.13.4

ARG KUBERNETES_VERSION=1.21.1
ARG REST_SERVER_VERSION=0.10.0

RUN export ARCH="$(uname -m)" && \
    if [[ ${ARCH} == "x86_64" ]]; then export ARCH="amd64"; \
    elif [[ ${ARCH} == "aarch64" ]]; then export ARCH="arm64"; \
    fi && \
    apk add --no-cache curl && \
    cd /usr/local/bin && \
    curl -sLO https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/${ARCH}/kubectl && \
    chmod +x kubectl && \
    cd /tmp && \
    curl -sLO https://github.com/restic/rest-server/releases/download/v${REST_SERVER_VERSION}/rest-server_${REST_SERVER_VERSION}_linux_${ARCH}.tar.gz && \
    tar -xzf rest-server_${REST_SERVER_VERSION}_linux_${ARCH}.tar.gz && \
    cp rest-server_${REST_SERVER_VERSION}_linux_${ARCH}/rest-server /usr/local/bin/rest-server && \
    rm -rf rest-server_${REST_SERVER_VERSION}_linux_${ARCH} rest-server_${REST_SERVER_VERSION}_linux_${ARCH}.tar.gz && \
    apk del curl

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

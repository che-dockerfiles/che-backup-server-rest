# Copyright (c) 2021 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#

FROM golang:1.16.5-alpine3.14 as builder

ENV REST_SERVER_TAG=v0.10.0
RUN apk add --no-cache git && \
    export ARCH="$(uname -m)" && \
    if [[ ${ARCH} == "x86_64" ]]; then export ARCH="amd64"; \
    elif [[ ${ARCH} == "aarch64" ]]; then export ARCH="arm64"; \
    fi && \
    mkdir -p /tmp/go && cd /tmp/go && \
    git clone --depth 1 --branch $REST_SERVER_TAG https://github.com/restic/rest-server.git && \
    cd rest-server && \
    go mod vendor && \
    GOOS=linux GOARCH=${ARCH} CGO_ENABLED=0 go build -mod=vendor -o rest-server  ./cmd/rest-server


FROM alpine:3.13.5

COPY --from=builder /tmp/go/rest-server/rest-server /usr/local/bin/rest-server
COPY --from=builder /tmp/go/rest-server/LICENSE /usr/local/bin/rest-server-LICENSE.txt

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

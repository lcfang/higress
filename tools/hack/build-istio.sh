# Copyright (c) 2023 Alibaba Group Holding Ltd.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#      http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#!/usr/bin/env bash

set -euo pipefail

TARGET_ARCH=${TARGET_ARCH-"amd64"}

ROOT=${PWD}

cd external/istio

CONDITIONAL_HOST_MOUNTS="\
    --mount "type=bind,source=${ROOT}/external/package,destination=/home/package" \
    --mount "type=bind,source=${ROOT},destination=/parent" \
"

GOOS_LOCAL=linux TARGET_OS=linux TARGET_ARCH=${TARGET_ARCH} \
    ISTIO_ENVOY_LINUX_RELEASE_URL="${ENVOY_PACKAGE_URL_PATTERN/ARCH/${TARGET_ARCH}}" \
    ISTIO_ENVOY_LINUX_RELEASE_PATH="${ENVOY_TAR_PATH_PATTERN/ARCH/${TARGET_ARCH}}" \
    ISTIO_ZTUNNEL_LINUX_RELEASE_PATH="${ZTUNNEL_PATH_PATTERN/ARCH/${TARGET_ARCH}}" \
    BUILD_WITH_CONTAINER=1 \
    CONDITIONAL_HOST_MOUNTS="${CONDITIONAL_HOST_MOUNTS}" \
    DOCKER_BUILD_VARIANTS=default DOCKER_TARGETS="docker.pilot" \
    make docker

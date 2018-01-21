#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
# 
#   http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

################################################################################
# Run pacat in a container. Illustrates running a pulseaudio client example
# in a container and forwarding the audio via the pulseaudio socket to the host.
# This script uses the simple approach of sharing the host's pulse socket with
# the container. This method requires the container and pulse server to be on
# the same host as the pulse socket is a Unix domain socket bind-mounted in
# the container. 
################################################################################

# If user isn't in docker group prefix docker with sudo 
if id -nG $(id -un) | grep -qw docker; then
    DOCKER_COMMAND=docker
else
    DOCKER_COMMAND="sudo docker"
fi

$DOCKER_COMMAND run --rm \
    -u $(id -u):$(id -g) \
    -e PULSE_SERVER=unix:$XDG_RUNTIME_DIR/pulse/native \
    -v $XDG_RUNTIME_DIR/pulse:$XDG_RUNTIME_DIR/pulse \
    pulseaudio-utils

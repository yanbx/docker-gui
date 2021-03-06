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
# Running Firefox by simple ssh X11 forwarding (ssh -X user@host) is painfully
# slow and the main reason for including this example is to illustrate how slow
# it is prior to presenting some much better ways to run remote applications.

BIN=$(cd $(dirname $0); echo ${PWD%docker-gui*})docker-gui/bin
. $BIN/docker-dbus-session-launch.sh # Run before remote-xauth and dbus-all
. $BIN/docker-command.sh
. $BIN/docker-remote-xauth.sh
. $BIN/docker-dbus-all.sh

# Create a directory on the host that we can mount as a
# "home directory" in the container for the current user.
mkdir -p $(id -un)/.config/dconf
$DOCKER_COMMAND run --rm \
    --shm-size 2g \
    -u $(id -u):$(id -g) \
    -v $PWD/$(id -un):/home/$(id -un) \
    -v /etc/passwd:/etc/passwd:ro \
    $APPARMOR_FLAGS \
    $DCONF_FLAGS \
    $X11_FLAGS \
    firefox


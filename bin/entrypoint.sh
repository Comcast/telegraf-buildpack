#!/usr/bin/env bash
#
# Copyright 2024 Comcast Cable Communications Management, LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

PATH="$PWD/bin:$PATH"

TELEGRAF_CONFIG_PATH=${TELEGRAF_CONFIG_PATH:-telegraf.conf}

TELEGRAF_CONFIG_DIRECTORY=${TELEGRAF_CONFIG_DIRECTORY:-conf}

config-influxdb-output.sh
config-global-tags.sh

exec telegraf -config-directory "$TELEGRAF_CONFIG_DIRECTORY" --config "$TELEGRAF_CONFIG_PATH"

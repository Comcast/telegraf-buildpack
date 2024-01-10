#!/usr/bin/env bash
#
# Copyright 2017 Comcast Cable Communications Management, LLC
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

set -e          # fail fast
set -o pipefail # do not ignore exit codes when piping output
set -u          # treat  unset variables as an error
# set -x          # enable debugging

# Generate global_tags.conf file from VCAP_SERVICES
# Service name must start with "tags"
# Example user provided service:
#   cf cups tags-telegraf -p '{"country":"us","state":"pa"}'
#
# VCAP_SERVICES='{
#   "user-provided": [
#    {
#     "credentials": {
#      "country": "us",
#      "state": "pa"
#     },
#     "label": "user-provided",
#     "name": "tags-telegraf",
#     "syslog_drain_url": "",
#     "tags": []
#    }
#   ]
# }'
#
# Result in conf/global_tags.conf file
# [global_tags]
#   country = "us"
#   state = "pa"

TELEGRAF_CONFIG_DIRECTORY=${TELEGRAF_CONFIG_DIRECTORY:-conf}
mkdir -p "$TELEGRAF_CONFIG_DIRECTORY"

jq <<<"$VCAP_SERVICES" >"$TELEGRAF_CONFIG_DIRECTORY"/global_tags.conf -r '
  flatten[]
  |select(.name|startswith("tags"))
  |.credentials
  |map_values("\"\(.)\"")
  |to_entries
  |map([.key, .value])
  |map(join(" = "))
  |["[global_tags]"] + .
  |join("\n  ")
'

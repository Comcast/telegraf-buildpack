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

set -e            # fail fast
set -o pipefail   # do not ignore exit codes when piping output
set -u            # treat  unset variables as an error
# set -x          # enable debugging

# Generate global_tags.conf file from VCAP_SERVICES
# Service name must start with "influx"
# Example user provided service:
#   cf cups influxdb -p url,database,retention_policy
#
# VCAP_SERVICES='{
#   "user-provided": [
#    {
#     "credentials": {
#      "database": "my-db",
#      "retention_policy": "default",
#      "url": "http://localhost:8086"
#     },
#     "label": "user-provided",
#     "name": "influxdb",
#     "syslog_drain_url": "",
#     "tags": []
#    }
#   ]
# }'
#
# Result in conf/influxdb.conf file
# [[outputs.influxdb]]
#   database = "my-db"
#   retention_policy = "default"
#   urls = ["http://localhost:8086"]

TELEGRAF_CONFIG_DIRECTORY=${TELEGRAF_CONFIG_DIRECTORY:-conf}
mkdir -p $TELEGRAF_CONFIG_DIRECTORY

jq <<< $VCAP_SERVICES > $TELEGRAF_CONFIG_DIRECTORY/influxdb.conf -r '
  flatten[]
  |select(.name|startswith("influx"))
  |.credentials
  |map_values("\"\(.)\"")
  |to_entries
  |map(
    if .key == "url" then
      ["urls", "[\(.value)]"]
    else
      [.key, .value]
    end
  )
  |map(join(" = "))
  |["[[outputs.influxdb]]"] + .
  |join("\n  ")
'

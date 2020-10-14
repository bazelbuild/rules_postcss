#!/bin/sh
# Copyright 2020 The Bazel Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

echo "argv is: $@"

executable=$1
shift

echo "wrapped executable is: $executable"

echo "sliced argv is: $@"

echo "running wrapped executable"

$executable $@

echo "finished running wrapped executable"

while [ $# -gt 0 ]; do
    if case $1 in "--outCssFile"*) true;; *) false;; esac; then
        # Take the argv after the flag --outCssFile
        shift
        outCssFile=$(printf '%s' "$1" | sed 's/--outCssFile=//')
    fi
    shift
done

echo "outCssFile is $outCssFile"

echo "/*hello!*/" >> $outCssFile

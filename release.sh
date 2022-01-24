


#!/bin/bash


scripts/specific/release_android.sh
scripts/specific/release_ios.sh

set -e

# Find and increment the version number.
perl -i -pe 's/^(version:\s+\d+\.\d+\.)(\d+)(\+)(\d+)$/$1.($2+1).$3.($4+1)/e' pubspec.yaml



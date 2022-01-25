


#!/bin/bash

flutter clean

scripts/specific/release_ios.sh || { echo 'release ios failed' ; exit 1;}
scripts/specific/release_android.sh || { echo 'release android failed' ; exit 1;}

# Find and increment the version number.
perl -i -pe 's/^(version:\s+\d+\.\d+\.)(\d+)(\+)(\d+)$/$1.($2+1).$3.($4+1)/e' pubspec.yaml



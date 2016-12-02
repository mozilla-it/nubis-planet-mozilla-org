#!/bin/bash -l
# Copy repository contents to web root
#

cd /opt/planet/build/
git clone https://github.com/mozilla/planet-content.git
git clone https://github.com/mozilla/planet-source.git
/opt/admin-scripts/planet.sh

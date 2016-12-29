#!/bin/bash -l

# Protect against parallel execution, only one copy can run at a time, we exit otherwise
# shellcheck disable=SC2015
exec 200<$0
flock -n 200 || exit 0

PLANETS="\
ateam \
bugzilla \
education \
firefox \
firefoxmobile \
firefox-os \
firefox-ux \
interns \
l10n \
mozillaonline \
mozillaopennews \
mozreview \
participation \
planet \
planet-de \
projects \
releng \
research
taskcluster \
thunderbird \
universalsubtitles \
webmademovies \
webmaker \
"

cd /data/static/build || exit 1

# "git clone" may fail if the directory is not empty
# Removing symlinks that may exist
/opt/admin-scripts/symlink_remove.sh

if [ ! -d "/data/static/build/planet-source/.git" ]; then
  git clone https://github.com/mozilla/planet-source.git planet-source
fi

if [ ! -d "/data/static/build/planet-content/.git" ]; then
  git clone https://github.com/mozilla/planet-content.git planet-content
fi

# Update repositories
cd /data/static/build/planet-source && git pull
rm -f /data/static/build/planet-content/trunk
cd /data/static/build/planet-content && git pull
cd /data/static/build || exit 1

# Add symlink to satisfy planet.py expectations
ln -s /data/static/build/planet-source/trunk/ /data/static/build/planet-content/trunk

# Restore symlinks
/opt/admin-scripts/symlink_add.sh

# Generate content
cd /data/static/build/planet-content/branches || exit 1

# XXX: GNU parallel a possible candidate here
for planet in $PLANETS; do
    (
      cd "$planet" || exit 1
      python ../../../planet-source/trunk/planet.py config.ini 2>&1 | tee /var/log/planet-$planet.log | sed -e"s/^/[$planet] /g"
    ) &
done

# Wait for all planet jobs to complete...
wait

#XXX: Atomic Rsync here?
cp -rf /data/static/src/planet.mozilla.org/* /var/www/html

exit 0

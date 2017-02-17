#!/bin/bash -l

# Protect against parallel execution, only one copy can run at a time, we exit otherwise
# shellcheck disable=SC2015
exec 200<"$0"
flock -n 200 || exit 0

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

# Run planet in parallel (Consider possibly timing-out jobs)
find /data/static/build/planet-content/branches -maxdepth 1 -mindepth 1 -type d | \
  /usr/local/bin/parallel --shuf -j 250% \
  "cd {} && python ../../../planet-source/trunk/planet.py config.ini 2>&1 | tee /var/log/planet-{/}.log | sed -e's/^/[{%}][{/}] /g'"

/usr/local/bin/atomic-rsync -a /data/genericrhel6/src/planet.mozilla.org/ /var/www/html/

exit 0

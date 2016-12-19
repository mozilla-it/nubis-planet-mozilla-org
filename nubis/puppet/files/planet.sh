#!/bin/bash

LOCKFILE=/tmp/locks/planet.lock
PLANETS="education mozillaonline bugzilla firefox firefoxmobile webmaker
firefox-ux webmademovies planet-de universalsubtitles interns research
mozillaopennews l10n ateam projects thunderbird firefox-os releng participation
taskcluster mozreview planet"

if [ ! -d /tmp/locks ]
then
  mkdir /tmp/locks
fi

if [ -f $LOCKFILE ]; then
  LOCKPID=`cat $LOCKFILE`
  ps $LOCKPID > /dev/null
  if [ $? -eq 0 ]
    then
      exit 0
    else
      echo "stale lockfile found removing"
      rm $LOCKFILE
  fi
fi

# Add PID to lockfile
echo $$ > $LOCKFILE

cd /data/static/build

if [ ! -d "/data/static/build/planet-source/.git" ]; then
  git clone https://github.com/mozilla/planet-source.git ./planet-source
fi

if [ ! -d "/data/static/build/planet-content/.git" ]; then
  git clone https://github.com/mozilla/planet-content.git ./planet-content
fi

# Update repositories
cd /data/static/build/planet-source && git pull
rm /data/static/build/planet-content/trunk
cd /data/static/build/planet-content && git pull
ln -s ../planet-source/trunk/ /data/static/build/planet-content/trunk

# Generate content
cd /data/static/build/planet-content
cd branches
for planet in $PLANETS; do
    cd $planet
    python ../../../planet-source/trunk/planet.py config.ini
    cd ..
done

cp -rf /data/static/src/planet.mozilla.org/* /var/www/html

rm -f $LOCKFILE

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

if [ ! -d "/data/static/build/planet-source/.git" ]; then
  CONTENT_DEST=/data/static/build/planet-source
  git clone https://github.com/mozilla/planet-source.git $CONTENT_DEST
fi

if [ ! -d "/data/static/build/planet-content/.git" ]; then
  CONTENT_DEST=/data/static/build/planet-content
  git clone https://github.com/mozilla/planet-content.git $CONTENT_DEST
fi

# Update repositories
cd /data/static/build/planet-source && git pull
cd /data/static/build/planet-content && git pull

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

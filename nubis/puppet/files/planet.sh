#!/bin/bash

LOCKFILE=/tmp/locks/planet.lock
PLANETS="planet education mozillaonline bugzilla firefox firefoxmobile webmaker firefox-ux webmademovies planet-de universalsubtitles interns research mozillaopennews l10n ateam projects thunderbird firefox-os releng participation taskcluster mozreview"

# Ensure that Python 2.7 is available (only tested with 2.6 and 2.7)
python --version 2>&1 | grep "2\.7" 2>&1>/dev/null
PYTHON_VER_CHECK=$?

if [ $PYTHON_VER_CHECK -ne 0 ]; then
  # Python is not available
  exit 1
fi

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

# Update repositories
cd /opt/planet/build/planet-source && git pull
cd /opt/planet/build/planet-content && git pull
cd /opt/planet/build/planet-content/branches

for planet in $PLANETS; do
  cd $planet
  /usr/bin/python2.6 ../../../planet-source/trunk/planet.py config.ini
  cd ..
done

rm -f $LOCKFILE

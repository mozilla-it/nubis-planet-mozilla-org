#!/bin/bash

LOCKFILE=/tmp/locks/planet.lock
PLANETS="planet education mozillaonline bugzilla firefox firefoxmobile webmaker
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

# This is embarassingly messy.
# Testing to ensure everything works. I will rewrite this after that.

function add_symlinks {
  sudo ln -s ../../../planet-content/branches/bugzilla/theme/ /data/static/build/planet-source/trunk/themes/moz_bugzilla
  sudo ln -s ../../../planet-content/branches/planet/theme/ /data/static/build/planet-source/trunk/themes/moz_planet
  sudo ln -s ../../../planet-content/branches/ateam/theme/ /data/static/build/planet-source/trunk/themes/moz_ateam
  sudo ln -s ../../../planet-content/branches/education/theme/ /data/static/build/planet-source/trunk/themes/moz_education
  sudo ln -s ../../../planet-content/branches/firefox/theme/ /data/static/build/planet-source/trunk/themes/moz_firefox
  sudo ln -s ../../../planet-content/branches/firefoxmobile/theme/ /data/static/build/planet-source/trunk/themes/moz_firefoxmobile
  sudo ln -s ../../../planet-content/branches/firefox-os/theme/ /data/static/build/planet-source/trunk/themes/moz_firefox-os
  sudo ln -s ../../../planet-content/branches/firefox-ux/theme/ /data/static/build/planet-source/trunk/themes/moz_firefox_ux
  sudo ln -s ../../../planet-content/branches/interns/theme/ /data/static/build/planet-source/trunk/themes/moz_interns
  sudo ln -s ../../../planet-content/branches/l10n/theme/ /data/static/build/planet-source/trunk/themes/moz_l10n
  sudo ln -s ../../../planet-content/branches/mozillaonline/theme/ /data/static/build/planet-source/trunk/themes/moz_mozillaonline
  sudo ln -s ../../../planet-content/branches/mozillaopennews/theme/ /data/static/build/planet-source/trunk/themes/moz_mozillaopennews
  sudo ln -s ../../../planet-content/branches/mozreview/theme/ /data/static/build/planet-source/trunk/themes/moz_mozreview
  sudo ln -s ../../../planet-content/branches/participation/theme/ /data/static/build/planet-source/trunk/themes/moz_participation
  sudo ln -s ../../../planet-content/branches/planet-de/theme/ /data/static/build/planet-source/trunk/themes/moz_planet_de
  sudo ln -s ../../../planet-content/branches/projects/theme/ /data/static/build/planet-source/trunk/themes/moz_projects
  sudo ln -s ../../../planet-content/branches/releng/theme/ /data/static/build/planet-source/trunk/themes/moz_releng
  sudo ln -s ../../../planet-content/branches/research/theme/ /data/static/build/planet-source/trunk/themes/moz_research
  sudo ln -s ../../../planet-content/branches/taskcluster/theme/ /data/static/build/planet-source/trunk/themes/moz_taskcluster
  sudo ln -s ../../../planet-content/branches/thunderbird/theme/ /data/static/build/planet-source/trunk/themes/moz_thunderbird
  sudo ln -s ../../../planet-content/branches/universalsubtitles/theme/ /data/static/build/planet-source/trunk/themes/moz_univeralsubtitles
  sudo ln -s ../../../planet-content/branches/webmademovies/theme/ /data/static/build/planet-source/trunk/themes/moz_webmademovies
  sudo ln -s ../../../planet-content/branches/webmaker/theme/ /data/static/build/planet-source/trunk/themes/moz_webmaker
}

function remove_symlinks {
  sudo rm -rf /data/static/build/planet-source/trunk/themes/moz_bugzilla
  sudo rm -rf /data/static/build/planet-source/trunk/themes/moz_planet
  sudo rm -rf /data/static/build/planet-source/trunk/themes/moz_ateam
  sudo rm -rf /data/static/build/planet-source/trunk/themes/moz_education
  sudo rm -rf /data/static/build/planet-source/trunk/themes/moz_firefox
  sudo rm -rf /data/static/build/planet-source/trunk/themes/moz_firefoxmobile
  sudo rm -rf /data/static/build/planet-source/trunk/themes/moz_firefox-os
  sudo rm -rf /data/static/build/planet-source/trunk/themes/moz_firefox_ux
  sudo rm -rf /data/static/build/planet-source/trunk/themes/moz_interns
  sudo rm -rf /data/static/build/planet-source/trunk/themes/moz_l10n
  sudo rm -rf /data/static/build/planet-source/trunk/themes/moz_mozillaonline
  sudo rm -rf /data/static/build/planet-source/trunk/themes/moz_mozillaopennews
  sudo rm -rf /data/static/build/planet-source/trunk/themes/moz_mozreview
  sudo rm -rf /data/static/build/planet-source/trunk/themes/moz_participation
  sudo rm -rf /data/static/build/planet-source/trunk/themes/moz_planet_de
  sudo rm -rf /data/static/build/planet-source/trunk/themes/moz_projects
  sudo rm -rf /data/static/build/planet-source/trunk/themes/moz_releng
  sudo rm -rf /data/static/build/planet-source/trunk/themes/moz_research
  sudo rm -rf /data/static/build/planet-source/trunk/themes/moz_taskcluster
  sudo rm -rf /data/static/build/planet-source/trunk/themes/moz_thunderbird
  sudo rm -rf /data/static/build/planet-source/trunk/themes/moz_univeralsubtitles
  sudo rm -rf /data/static/build/planet-source/trunk/themes/moz_webmademovies
  sudo rm -rf /data/static/build/planet-source/trunk/themes/moz_webmaker
}

# Update repositories
remove_symlinks
cd /data/static/build/planet-source && git pull
rm /data/static/build/planet-content/trunk
cd /data/static/build/planet-content && git pull
ln -s ../planet-source/trunk/ /data/static/build/planet-content/trunk
add_symlinks

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

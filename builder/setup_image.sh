#!/bin/sh

# This should run in the context of the pi to set it up as a nice platform for purr-data

# install a bunch of tools & plugins
apt install -y ladspa-sdk dssi-dev tap-plugins invada-studio-plugins-ladspa blepvco swh-plugins mcp-plugins cmt blop omins rev-plugins dssi-utils vco-plugins wah-plugins fil-plugins mda-lv2 fluid-soundfont-gm

# install my built version of purr-data
apt install -y /usr/rpi/pd-l2ork-2.9.0-20190624-rev.e2b3cc4a-armv7l.deb

# copy data-files to mounted boot
cp -R /usr/rpi/builder/pi/boot/* /boot

cp -R /usr/rpi/builder/pi/pipurr.sh /usr/bin/pipurr
chmod 755 /usr/bin/pipurr

cp /usr/rpi/builder/pi/pipurr.service /usr/lib/systemd/system/pipurr.service
systemctl enable pipurr
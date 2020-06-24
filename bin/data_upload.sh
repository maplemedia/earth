#!/bin/bash
##################
# this file was used when the ftp upload was utilized to update the weather pattern data.
# The FTP upload has apparently been broken for a while so this is no longer needed
# This script is ran from heroku scheduler ever hour but since it is not needed, it can be disabled or removed
# leaving it here just commented out to provide an example of what it was doing in case updates need to happen more often
# currently updates only happen on pushes to master which triggers a deploy, but this process was so there could be intermittent updates without a deploy
##################
#cd public/data/weather/current
#rm current-wind-surface-level-gfs-1.0.json
#curl -s http://anapaapps.com/earth/current-wind-surface-level-gfs-1.0.json > current-wind-surface-level-gfs-1.0.json
#pwd
#ls -a -o

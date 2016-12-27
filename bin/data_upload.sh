#!/bin/bash
cd public/data/weather/current
rm current-wind-surface-level-gfs-1.0.json
curl -s http://anapaapps.com/earth/current-wind-surface-level-gfs-1.0.json > current-wind-surface-level-gfs-1.0.json
pwd
ls -a -o
curl -s http://status.anapaapps.com/update.php --user-agent "heroku earth update"

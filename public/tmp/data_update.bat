set CURRENTTIME=%time:~0,2%
set T=18
::seems to still get 18 when ran automatically...
if %CURRENTTIME%==0 set T=00
if %CURRENTTIME%==1 set T=00
if %CURRENTTIME%==2 set T=00
if %CURRENTTIME%==3 set T=00
if %CURRENTTIME%==4 set T=06
if %CURRENTTIME%==5 set T=06
if %CURRENTTIME%==6 set T=06
if %CURRENTTIME%==7 set T=06
if %CURRENTTIME%==8 set T=06
if %CURRENTTIME%==9 set T=06
if %CURRENTTIME%==10 set T=12
if %CURRENTTIME%==11 set T=12
if %CURRENTTIME%==12 set T=12
if %CURRENTTIME%==13 set T=12
if %CURRENTTIME%==14 set T=12
if %CURRENTTIME%==15 set T=12
set YYYYMMDD=%date:~10,4%%date:~4,2%%date:~7,2%

:download
cd
::this is the initial download url of the file to use for weather data
set URL="https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p50.pl?file=gfs.t%T%z.pgrb2full.0p50.f000&lev_10_m_above_ground=on&var_UGRD=on&var_VGRD=on&leftlon=0&rightlon=360&toplat=90&bottomlat=-90&dir=/gfs.%YYYYMMDD%/%T%"
::just echoing for logs to validate it built correctly, they changed the path once or twice over the last couple years
echo %URL%
::dump any current files so we can ensure we get clean data
del current*.json
del *.grib2
::grab the file
curl %URL% -o gfs.grib2
::running the grib2json command to convert it to the format we need
::grib2json is also forked on https://github.com/Colbey/grib2json
start "running grib" /b /wait cmd /c grib2json -d -n -v -c -o current-wind-surface-level-gfs-1.0.json gfs.grib2
::sometimes the file is not quite ready, this will advance it until we find one that is
if not exist current-wind-surface-level-gfs-1.0.json goto :adjustit
::dumping current repo version
del ..\data\weather\current\current-wind-surface-level-gfs-1.0.json
::moving the newly created version into place
copy current-wind-surface-level-gfs-1.0.json ..\data\weather\current
::cleaning up
del *.grib2
::initially we had an ftp upload process but that has not been wired up and working for a while
::start "running upload" /b /wait cmd /c ftp_upload.bat current-wind-surface-level-gfs-1.0.json
del current*.json
::pushes to git which triggers a heroku deploy
if %CURRENTTIME%==23 (
    git add -A :/
    git commit -m "data update %YYYYMMDD%%T%"
    git push origin master
)
::pushed to git to trigger a deploy and restarts the dyno to help keep caches cleaned up
IF %CURRENTTIME%==11 (
    git add -A :/
    git commit -m "data update %YYYYMMDD%%T%"
    git push origin master
	heroku ps:restart -a earth-windcompass
)
::make sure to hit heroku to wake the app up to reduce response times
curl https://earth-windcompass.herokuapp.com -k > NUL
exit /b 0

:adjustit
if %T%==00 goto :errored
if %T%==06 set T=00
if %T%==12 set T=06
if %T%==18 set T=12
goto :download

:errored
echo "invalid file"
del *.grib2
del current*.json
exit /b 1

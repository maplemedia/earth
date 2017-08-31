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
set URL="http://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p50.pl?file=gfs.t%T%z.pgrb2full.0p50.f000&lev_10_m_above_ground=on&var_UGRD=on&var_VGRD=on&leftlon=0&rightlon=360&toplat=90&bottomlat=-90&dir=/gfs.%YYYYMMDD%%T%"
echo %URL%
del current*.json
del *.grib2
curl %URL% -o gfs.grib2
start "running grib" /b /wait cmd /c grib2json -d -n -v -c -o current-wind-surface-level-gfs-1.0.json gfs.grib2
if not exist current-wind-surface-level-gfs-1.0.json goto :adjustit
del ..\data\weather\current\current-wind-surface-level-gfs-1.0.json
copy current-wind-surface-level-gfs-1.0.json ..\data\weather\current
del *.grib2
start "running upload" /b /wait cmd /c ftp_upload.bat current-wind-surface-level-gfs-1.0.json
del current*.json
if %CURRENTTIME%==23 (
    git add -A :/
    git commit -m "data update %YYYYMMDD%%T%"
    git push origin master
    curl http://status.anapaapps.com/update.php --user-agent "git pushed %YYYYMMDD%%T%"
)
IF %CURRENTTIME%==11 (
    git add -A :/
    git commit -m "data update %YYYYMMDD%%T%"
    git push origin master
	heroku ps:restart -a earth-windcompass
    curl http://status.anapaapps.com/update.php --user-agent "git pushed %YYYYMMDD%%T%"
)
curl http://status.anapaapps.com/update.php --user-agent "earth updated %YYYYMMDD%%T%"
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
curl http://status.anapaapps.com/update.php --user-agent "earth update failed %YYYYMMDD%%T%"
exit /b 1

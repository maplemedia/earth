YYYYMMDD=`date +%Y%m%d`
CURRENTTIME=`date +%H`
T="00"
if test "$CURRENTTIME" == "00"
then
  T="00"
elif test "$CURRENTTIME" == "01"
then
  T="00"
elif test "$CURRENTTIME" == "02"
then
  T="00"
elif test "$CURRENTTIME" == "03"
then
  T="06"
elif test "$CURRENTTIME" == "04"
then
  T="06"
elif test "$CURRENTTIME" == "05"
then
  T="06"
elif test "$CURRENTTIME" == "06"
then
  T="06"
elif test "$CURRENTTIME" == "07"
then
  T="06"
elif test "$CURRENTTIME" == "08"
then
  T="06"
elif test "$CURRENTTIME" == "09"
then
  T="12"
elif test "$CURRENTTIME" == "10"
then
  T="12"
elif test "$CURRENTTIME" == "11"
then
  T="12"
elif test "$CURRENTTIME" == "12"
then
  T="12"
elif test "$CURRENTTIME" == "13"
then
  T="12"
elif test "$CURRENTTIME" == "14"
then
  T="12"
else
  T="18"
fi
##this is the 1 degree which does not work
##URL="http://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_1p00.pl?file=gfs.t${T}z.pgrb2.1p00.anl&lev_10_m_above_ground=on&var_UGRD=on&var_VGRD=on&leftlon=0&rightlon=360&toplat=90&bottomlat=-90&dir=%2Fgfs.${YYYYMMDD}${T}"
##URL="http://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p50.pl?file=gfs.t${T}z.pgrb2full.0p50.f000&lev_10_m_above_ground=on&var_UGRD=on&var_VGRD=on&leftlon=0&rightlon=360&toplat=90&bottomlat=-90&dir=%2Fgfs.${YYYYMMDD}${T}"
##this is the  0.5 degree which works
URL="http://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p50.pl?file=gfs.t${T}z.pgrb2full.0p50.f000&lev_10_m_above_ground=on&var_UGRD=on&var_VGRD=on&leftlon=0&rightlon=360&toplat=90&bottomlat=-90&dir=%2Fgfs.${YYYYMMDD}${T}"
echo $URL
curl $URL -o gfs.grib2
grib2json -d -n -v -c -o current-wind-surface-level-gfs-1.0.json gfs.grib2
if [ -f "current-wind-surface-level-gfs-1.0.json" ]
then  
  echo "exists, continuing"
else
  rm *.json
  rm *.grib2
  echo "no file found"
  exit 0
fi

cp current-wind-surface-level-gfs-1.0.json ../data/weather/current
echo "copied"

ftp -d -N '.netrc' anapaapps.com << ftp_eof
  put current-wind-surface-level-gfs-1.0.json
  quit
ftp_eof

rm *.json
rm *.grib2
##in the end of the url, there is a %2F which translates to / on a *nix system but on windows is not decoded and invalidates the URL


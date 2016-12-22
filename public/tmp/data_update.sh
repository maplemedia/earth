YYYYMMDD=`date +%Y%m%d`
curl "http://nomads.ncep.noaa.gov/cgi-bin/filter_gfs.pl?file=gfs.t00z.pgrbf00.grib2&lev_10_m_above_ground=on&var_UGRD=on&var_VGRD=on&dir=%2Fgfs.${YYYYMMDD}00" -o gfs.t00z.pgrbf00.grib2
grib2json -d -n -o current-wind-surface-level-gfs-1.0.json gfs.t00z.pgrbf00.grib2
cp current-wind-surface-level-gfs-1.0.json ../data/weather/current
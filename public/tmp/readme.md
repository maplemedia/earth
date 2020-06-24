#General Rundown

The data_update.bat file is scheduled to run every hour but only updates the repo every 12 hours so the scheduling can be reduced.
What the file does is hit the NOAA data portal to grab the grib file which is the format they store the weather data in.
Then the grib2json (https://github.com/Colbey/grib2json) converts it to the format the node.js app needs.
From there, we were uploading it hourly but apparently my current webhost broke the FTP access so that has been broken for a while.
Alternatively, it is updated every 12 hours via a git push which triggers heroku to grab all the files and refresh the app.

The rest of the logic in the data_upload.bat is just put around grabbing the file from NOAA because sometimes files are not available for the specific time period so we have to try a different file by building out a different path to check. Unfortunately they will host an empty file for a given timeframe which is why we download and check the successful conversion to json or try again with a new path.

The data_update.sh was from when i had a *nix system running locally, it  was basically the same process. But the .bat file is what has been updating the file for the last couple years.

The borders_update.sh is to create the border files for country outlines. it is more of a one and done sort of thing. There is no automated process to run it, or no need to run it often so long as major borders to countries do not change.
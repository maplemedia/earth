echo user %FTP_UPLOAD_US%> ftpcmd.dat
echo %FTP_UPLOAD_PW%>> ftpcmd.dat
echo delete %1>> ftpcmd.dat
echo put %1>> ftpcmd.dat
echo quit>> ftpcmd.dat
ftp -n -s:ftpcmd.dat anapaapps.com
del ftpcmd.dat
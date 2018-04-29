winscp.com /command ^
    "open ftp://%FTP_UPLOAD_US%:%FTP_UPLOAD_PW%@anapaapps.com/" ^
 	"option confirm off" ^
    "rm %1" ^
    "put -transfer=binary %1" ^
    "exit"
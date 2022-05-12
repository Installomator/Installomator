filezilla)
    name="FileZilla"
    type="tbz"
    packageID="org.filezilla-project.filezilla"
    downloadURL=$(curl -fsL https://filezilla-project.org/download.php\?show_all=1 | grep macosx | head -n 1 | awk -F '"' '{print $2}' )
    appNewVersion=$( curl -fsL https://filezilla-project.org/download.php\?show_all=1 | grep macosx | head -n 1 | awk -F '_' '{print $2}' )
    expectedTeamID="5VPGKXL75N"
    blockingProcesses=( NONE )
    ;;


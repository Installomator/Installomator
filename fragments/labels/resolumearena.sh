resolumearena)
    name="Resolume Arena"
    appName="Resolume Arena/Arena.app"
    type="pkgInDmg"
    pkgName="Resolume Arena Installer.pkg"
    resolumeDownloadPage=$(curl -fsL "https://resolume.com/download/?file=latest_arena")
    resolumeDownloadFile=$(awk -F'"' '/Resolume_Arena.*_Installer\.dmg/ && !/No_Footage/ { print $2; exit }' <<< "$resolumeDownloadPage")
    downloadURL=$(awk -F'"' '/src="\/\/.*\.dmg"/ { print "https:" $2; exit }' <<< "$(curl -fsL "$resolumeDownloadFile")")
    appNewVersion=$(sed -E 's/.*Arena_([0-9]{1,2})_([0-9]{1,2})_([0-9]{1,2})_.*/\1.\2.\3/' <<< "$downloadURL")
    blockingProcesses=( "Arena" "Alley" "Wire" )
    expectedTeamID="Z9Y8N6Q4L8"
    ;;

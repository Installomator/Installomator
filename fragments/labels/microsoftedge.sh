microsoftedge|\
microsoftedgeconsumerstable|\
microsoftedgeenterprisestable)
    name="Microsoft Edge"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=2093504"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.edge"]/cfbundleversion' 2>/dev/null | sed -E 's/<cfbundleversion>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/MicrosoftEdge.*pkg" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g')
    #appNewVersion="113.2" # For test of updateTool
    expectedTeamID="UBF8T346G9"
    orgFolderPath=$(pwd)
    folderPath=$(cd /Library/Microsoft/EdgeUpdater/[0-9.]*/EdgeUpdater.app/Contents/MacOS/ && pwd)
    if [[ -x "${folderPath}/EdgeUpdater" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        # This part might not be needed
    fi
    updateTool=${folderPath}/EdgeUpdater
    updateToolArguments=( --service=update --enable-logging --system )
    cd "$orgFolderPath"
    ;;

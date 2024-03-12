microsoftremotedesktop)
    name="Microsoft Remote Desktop"
    type="pkg"
    appName="$name.app"
    versionKey="CFBundleVersion"
    expectedTeamID="UBF8T346G9"
    msid="MSRD10"
    linkid="868963"
    downloadURL=$(curl -fsIL "https://go.microsoft.com/fwlink/?linkid=${linkid}" | grep -i location: | awk -F': ' '{ print $2 }' | tr -d '\n' | sed 's/pkg.*/pkg/')
    getAppVersion
    if [[ $appversion && $INSTALL != "force" ]]; then
        printlog "Grabbing updater URL for updater"
        updaterURL=$(curl -s https://officecdn.microsoft.com/pr/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/0409${msid}.xml | xmllint --format --xpath ".//*/key[text()='Location']/following-sibling::*[1]" - | awk -F'<string>' '{ print $2 }' | sed 's/<.*//' | grep -i "_Updater"| tr -d '\n' | sed 's/pkg.*/pkg/')
    fi
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        toolOutput=$("/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list | grep -c 'XPC Connection to updater invalidated')
    else
        toolOutput="99"
    fi
    
    if [[ $toolOutput -eq 0 ]]; then
        printlog "XPC Connection to msupdate succesfull, setting msupdate as update tool"
        updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
        updateToolArguments=( --install --apps ${msid} )
    elif [[ $toolOutput -eq 99 ]]; then
        printlog "force/debug set or msupdate unavailable, update tool not set"
    elif [[ $toolOutput -ne 0 ]]; then
        printlog "XPC Connection to updater invalidated or otherwise failed, update tool not set"
    fi
    if [[ $updaterURL && $INSTALL != "force" ]]; then
        printlog "Setting downloadURL to updaterURL"
        downloadURL="$updaterURL"
    fi
    
    appNewVersion=$(echo $downloadURL | grep -o "/Microsoft_.*pkg" | cut -d "_" -f 4 | cut -d "." -f 1-3)

    ;;

microsoftexcel)
    name="Microsoft Excel"
    type="pkg"
    appName="$name.app"
    versionKey="CFBundleVersion"
    expectedTeamID="UBF8T346G9"
    msid="XCEL2019"
    linkid="525135"
    downloadURL=$(curl -fsIL "https://go.microsoft.com/fwlink/?linkid=${linkid}" | grep -i location: | awk -F': ' '{ print $2 }' | tr -d '\n' | sed 's/pkg.*/pkg/')
    getAppVersion
    if [[ $appversion && $INSTALL != "force" ]]; then
        printlog "Grabbing updater URL for Delta update"
        updaterURL=$(curl -s https://officecdn.microsoft.com/pr/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/0409${msid}.xml | xmllint --format --xpath ".//*/key[text()='Location']/following-sibling::*[1]" - | awk -F'<string>' '{ print $2 }' | sed 's/<.*//' | grep "${appversion}_to_" | grep -v "_to_${appversion}" | tr -d '\n' | sed 's/pkg.*/pkg/')
    fi
    if [[ ! $updaterURL && $appversion ]]; then
        printlog "No Delta found...grabbing full updater URL"
        updaterURL=$(curl -s https://officecdn.microsoft.com/pr/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/0409${msid}.xml | xmllint --format --xpath ".//*/key[text()='FullUpdaterLocation']/following-sibling::*[1]" - | awk -F'<string>' '{ print $2 }' | sed 's/<.*//' | grep "_Updater"| tr -d '\n' | sed 's/pkg.*/pkg/')
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
    if [[ $(echo $downloadURL | grep '_to_') ]]; then
        printlog "Setting appNewVersion to Delta version"
        appNewVersion=$(echo $downloadURL | awk -F'_to_' '{ print $2 }' | sed 's/_.*//')
    else
        printlog "Setting appNewVersion to Installer/Updater version"
        appNewVersion=$(echo $downloadURL | grep -o "/Microsoft_.*pkg" | cut -d "_" -f 3 | cut -d "." -f 1-3)
    fi
    ;;

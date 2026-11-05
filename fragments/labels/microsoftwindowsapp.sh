microsoftwindowsapp|\
microsoftremotedesktop)
    name="Windows App"
    type="pkg"
    MAUSource="https://res.public.onecdn.static.microsoft/mro1cdnstorage/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/0409MSRD10.xml"
    downloadURL=$(curl -fsL $MAUSource | xmllint --xpath '//array/dict[1]/key[text()="Location"]/following-sibling::string[1]/text()' - | sed 's/_updater/_installer/' 2>/dev/null)
    appNewVersion=$(curl -fsL $MAUSource | xmllint --xpath '//array/dict[1]/key[text()="Title"]/following-sibling::string[1]/text()' - | grep -oE '[\.0-9]*' 2>/dev/null)
    expectedTeamID="UBF8T346G9"
    MAUChannel=""
    MAUAppChannel=""
    MAUAppsFound=""
    for MAUPrefs in "/Library/Managed Preferences/com.microsoft.autoupdate2" "user" "/Library/Preferences/com.microsoft.autoupdate2"; do
        if [[ $MAUPrefs == "user" ]]; then
            [[ -n $currentUser && $currentUser != "loginwindow" ]] || continue
            MAUPrefsXML=$(runAsUser defaults export com.microsoft.autoupdate2 - 2>/dev/null)
        else
            MAUPrefsXML=$(defaults export "$MAUPrefs" - 2>/dev/null)
        fi
        [[ -n $MAUChannel ]] || MAUChannel=$(xmllint --xpath "string(/plist/dict/key[.='ChannelName']/following-sibling::*[1])" - <<< "$MAUPrefsXML" 2>/dev/null)
        if [[ -z $MAUAppsFound ]] && xmllint --xpath "/plist/dict/key[.='Applications']" - <<< "$MAUPrefsXML" >/dev/null 2>&1; then
            MAUAppsFound=1
            MAUAppChannel=$(xmllint --xpath "string(/plist/dict/key[.='Applications']/following-sibling::dict[1]/dict[key[.='Application ID']/following-sibling::*[1][.='MSRD10']]/key[.='ChannelName']/following-sibling::*[1])" - <<< "$MAUPrefsXML" 2>/dev/null)
        fi
    done
    [[ -n $MAUAppChannel ]] && MAUChannel=$MAUAppChannel
    if [[ $MAUChannel == (Preview|External|InsiderSlow|Beta|InsiderFast) ]]; then
        printlog "MAU channel for Windows App is $MAUChannel, which doesn't update it, so not using msupdate"
    else
        if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
            printlog "Running msupdate --list"
            "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
        fi
        updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
        updateToolArguments=( --install --apps MSRD10 )
    fi
    ;;

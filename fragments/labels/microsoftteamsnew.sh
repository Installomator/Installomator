microsoftteamsnew)
    name="Microsoft Teams"
    type="pkg"
    MAUSource="https://res.public.onecdn.static.microsoft/mro1cdnstorage/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/0409TEAMS21.xml"
    mauXML=$(curl -fsL "$MAUSource")
    appNewVersion=$(printf '%s' "$mauXML" | xmllint --xpath 'string((//dict[key[text()="Application ID"]/following-sibling::string[1]="TEAMS21" and key[text()="Location"]/following-sibling::string[1][contains(.,"/MicrosoftTeams.pkg")]]/key[text()="Update Version"]/following-sibling::string[1])[1])' - 2>/dev/null)
    downloadURL=$(printf '%s' "$mauXML" | xmllint --xpath 'string((//dict[key[text()="Application ID"]/following-sibling::string[1]="TEAMS21" and key[text()="Location"]/following-sibling::string[1][contains(.,"/MicrosoftTeams.pkg")]]/key[text()="Location"]/following-sibling::string[1])[1])' - 2>/dev/null)
    expectedTeamID="UBF8T346G9"
    blockingProcesses=( MSTeams "Microsoft Teams" "Microsoft Teams WebView" "Microsoft Teams Launcher" "Microsoft Teams (work preview)")
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps TEAMS21 )
    ;;

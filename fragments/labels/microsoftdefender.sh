microsoftdefender|\
microsoftdefenderatp)
    name="Microsoft Defender"
    type="pkg"
    MAUSource="https://officecdnmac.microsoft.com/pr/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/0409WDAV00.xml"
    downloadURL=$(curl -fsL $MAUSource | xmllint --xpath '//array/dict[1]/key[text()="Location"]/following-sibling::string[1]/text()' - | sed 's/-upgrade//' 2>/dev/null)
    appNewVersion=$(curl -fsL $MAUSource | xmllint --xpath '//array/dict[1]/key[text()="Update Version"]/following-sibling::string[1]/text()' - 2>/dev/null)
    expectedTeamID="UBF8T346G9"
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps WDAV00 )
    ;;

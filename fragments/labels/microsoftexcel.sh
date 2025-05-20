microsoftexcel)
    name="Microsoft Excel"
    type="pkg"
    MAUSource="https://officecdnmac.microsoft.com/pr/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/0409XCEL2019.xml"
    downloadURL=$(curl -fsL $MAUSource | xmllint --xpath '//array/dict[1]/key[text()="FullUpdaterLocation"]/following-sibling::string[1]/text()' - | sed 's/_Updater/_Installer/' 2>/dev/null)
    appNewVersion=$(curl -fsL $MAUSource | xmllint --xpath '//array/dict[1]/key[text()="Update Version"]/following-sibling::string[1]/text()' - 2>/dev/null)
    expectedTeamID="UBF8T346G9"
    versionKey="CFBundleVersion"
    if [[ -x "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" && $INSTALL != "force" && $DEBUG -eq 0 ]]; then
        printlog "Running msupdate --list"
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" --list
    fi
    blockingProcesses=( "Microsoft Excel" )
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps XCEL2019 )
    ;;

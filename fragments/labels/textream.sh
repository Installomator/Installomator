textream)
    name="Textream"
    type="dmg"
    osMajorVersion=$(sw_vers -productVersion | awk -F '.' '{print $1}')
    if [[ "$osMajorVersion" -ge 26 ]]; then
        archiveName="Textream.dmg"
    elif [[ "$osMajorVersion" -eq 15 ]]; then
        archiveName="Textream-macos15.dmg"
    else
        printlog "Textream requires macOS 15 or later." ERROR
        cleanupAndExit 95 "Unsupported macOS version" ERROR
    fi
    downloadURL=$(downloadURLFromGit f textream)
    appNewVersion=$(versionFromGit f textream)
    expectedTeamID="RJA7656U34"
    ;;

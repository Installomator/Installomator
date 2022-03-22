onlyofficedesktop)
    name="ONLYOFFICE"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
    downloadURL="https://download.onlyoffice.com/install/desktop/editors/mac/arm/distrib/ONLYOFFICE.dmg"
    elif [[ $(arch) == "i386" ]]; then
    downloadURL="https://download.onlyoffice.com/install/desktop/editors/mac/x86_64/distrib/ONLYOFFICE.dmg"
    fi
    appNewVersion=$(versionFromGit ONLYOFFICE DesktopEditors)
    expectedTeamID="2WH24U26GJ"
    ;;

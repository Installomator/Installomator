rodecasterapp)
    name="RODECaster App"
    type="pkgInZip"
    downloadURL="https://update.rode.com/rc-app/RODECaster_App_MACOS.zip"
    appNewVersion=$(curl -fLs https://rode.com/en/release-notes/rodecaster-app | grep -oE "Version [0-9]+\.[0-9]+\.[0-9.]*" | awk '{print $2}' | sort --version-sort | tail -1)
    expectedTeamID="Z9T72PWTJA"
    ;;

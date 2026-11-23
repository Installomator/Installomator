aegisub)
    name="Aegisub"
    type="dmg"
    appNewVersion="$(versionFromGit TypesettingTools Aegisub)"
    expectedTeamID="7NZK26BU3C"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="Aegisub-${appNewVersion}-arm64.dmg"
    else
        archiveName="Aegisub-${appNewVersion}-x64.dmg"
    fi
    downloadURL="$(downloadURLFromGit TypesettingTools Aegisub)"
    ;;

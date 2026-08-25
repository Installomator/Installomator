beekeeperstudio)
    name="Beekeeper Studio"
    type="dmg"
    appNewVersion="$(versionFromGit beekeeper-studio beekeeper-studio)"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="Beekeeper-Studio-${appNewVersion}-arm64.dmg"
    else
        archiveName="Beekeeper-Studio-${appNewVersion}.dmg"
    fi
    downloadURL="$(downloadURLFromGit beekeeper-studio beekeeper-studio)"
    expectedTeamID="7KK583U8H2"
    ;;

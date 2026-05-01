beekeeperstudio)
    name="Beekeeper Studio"
    type="dmg"
    appNewVersion="$(versionFromGit beekeeper-studio beekeeper-studio)"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${appNewVersion}/Beekeeper-Studio-${appNewVersion}-arm64.dmg"
    else
        downloadURL="https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${appNewVersion}/Beekeeper-Studio-${appNewVersion}.dmg"
    fi
    expectedTeamID="7KK583U8H2"
    ;;

mongodbcompass)
    name="MongoDB Compass"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="mongodb-compass-[0-9.]*-darwin-arm64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="mongodb-compass-[0-9.]*-darwin-x64.dmg"
    fi
    downloadURL="$(downloadURLFromGit mongodb-js compass)"
    appNewVersion="$(versionFromGit mongodb-js compass)"
    expectedTeamID="4XWMY46275"
    ;;

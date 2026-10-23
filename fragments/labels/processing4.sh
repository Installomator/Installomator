processing4)
    name="Processing"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="macos-aarch64.dmg"
    else
        archiveName="macos-x64.dmg"
    fi
    downloadURL=$(downloadURLFromGit processing processing4)
    appNewVersion=$(echo "$downloadURL" | sed -E 's#.*/processing-([0-9.]+)-macos-(aarch64|x64)\.dmg$#\1#')
    expectedTeamID="6297K33652"
    ;;

raindropio)
    name="Raindrop.io"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
        archiveName="Raindrop-x64.dmg"
    elif [[ $(arch) == arm64 ]]; then
        archiveName="Raindrop-arm64.dmg"
    fi

    downloadURL=$(downloadURLFromGit raindropio desktop )
    appNewVersion=$(versionFromGit raindropio desktop )
    expectedTeamID="7459JWM5TY"
    ;;

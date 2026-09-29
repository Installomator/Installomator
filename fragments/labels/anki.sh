anki)
    name="Anki"
    type="dmg"
    appNewVersion=$(versionFromGit ankitects anki | sed -E 's/\.0([0-9])/\.\1/g')
    if [[ $(arch) == "arm64" ]]; then
        archiveName="mac-apple.dmg"
    else
        archiveName="mac-intel.dmg"
    fi
    downloadURL=$(downloadURLFromGit ankitects anki)
    expectedTeamID="ZL66D3NMZM"
    ;;

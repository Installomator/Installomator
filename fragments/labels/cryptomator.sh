cryptomator)
    name="Cryptomator"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="Cryptomator-[0-9.]*-arm64.dmg"

    elif [[ $(arch) == "i386" ]]; then
        archiveName="Cryptomator-[0-9.]*-x64.dmg"
    fi
    downloadURL=$(downloadURLFromGit cryptomator cryptomator)
    appNewVersion=$(versionFromGit cryptomator cryptomator)
    expectedTeamID="YZQJQUHA3L"
    ;;

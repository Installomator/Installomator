losslesscut)
    name="LosslessCut"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="LosslessCut-mac-arm64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="LosslessCut-mac-x64.dmg"
    fi
    versionKey="CFBundleShortVersionString"
    downloadURL=$(downloadURLFromGit mifi lossless-cut)
    appNewVersion=$(versionFromGit mifi lossless-cut)
    expectedTeamID="46F6T3M669"
    ;;

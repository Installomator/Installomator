sessiondesktop)
    name="Session"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="session-desktop-mac-arm64-[0-9.]*.dmg"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="session-desktop-mac-x64-[0-9.]*.dmg"
    fi
    versionKey="CFBundleShortVersionString"
    downloadURL=$(downloadURLFromGit session-foundation session-desktop)
    appNewVersion=$(versionFromGit session-foundation session-desktop)
    expectedTeamID="SUQ8J2PCT7"
    ;;

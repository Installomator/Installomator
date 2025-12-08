obs)
    name="OBS"
    appName="OBS.app"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="OBS-Studio-[0-9.]*-macOS-Apple.dmg"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="OBS-Studio-[0-9.]*-macOS-Intel.dmg"
    fi
    downloadURL=$(downloadURLFromGit obsproject obs-studio )
    appNewVersion=$(versionFromGit obsproject obs-studio )
    expectedTeamID="2MMRE5MTB8"
    ;;

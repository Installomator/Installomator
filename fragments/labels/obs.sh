obs)
    name="OBS"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="obs-studio-[0-9.]*-macos-arm64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="obs-studio-[0-9.]*-macos-x86_64.dmg"
    fi
    downloadURL=$(downloadURLFromGit obsproject obs-studio )
    appNewVersion=$(versionFromGit obsproject obs-studio )
    expectedTeamID="2MMRE5MTB8"
    ;;

ultimakercura)
    name="Ultimaker Cura"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="UltiMaker-Cura-[0-9.]*-macos-ARM64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="UltiMaker-Cura-[0-9.]*-macos-X64.dmg"
    fi
    downloadURL="$(downloadURLFromGit Ultimaker Cura)"
    appNewVersion=$(versionFromGit Ultimaker Cura )
    expectedTeamID="V4B3JXRRQS"
    ;;

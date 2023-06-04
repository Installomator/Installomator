jasp)
    name="JASP"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="JASP-[0-9.]*-macOS-arm64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="JASP-[0-9.]*-macOS-x86_64.dmg"
    fi
    downloadURL=$(downloadURLFromGit jasp-stats jasp-desktop )
    appNewVersion=$(versionFromGit jasp-stats jasp-desktop )
    expectedTeamID="AWJJ3YVK9B"
    ;;

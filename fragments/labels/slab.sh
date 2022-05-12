slab)
    name="Slab"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
       archiveName="Slab-[0-9.]*-darwin-x64.dmg"
    elif [[ $(arch) == arm64 ]]; then
       archiveName="Slab-[0-9.]*-darwin-arm64.dmg"
    fi
    downloadURL=$(downloadURLFromGit slab desktop-releases)
    appNewVersion=$(versionFromGit slab desktop-releases)
    expectedTeamID="Q67SW996Z5"
    ;;

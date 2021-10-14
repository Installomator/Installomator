hyper)
    name="Hyper"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
      archiveName="mac-x64.dmg"
    elif [[ $(arch) == arm64 ]]; then
      archiveName="mac-arm64.dmg"
    fi
    downloadURL=$(downloadURLFromGit vercel hyper )
    appNewVersion=$(versionFromGit vercel hyper)
    expectedTeamID="JW6Y669B67"
    ;;

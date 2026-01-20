phoenixcode)
    name="Phoenix Code"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
      archiveName="x64.dmg"
    elif [[ $(arch) == arm64 ]]; then
      archiveName="aarch64.dmg"
    fi
    downloadURL="$(downloadURLFromGit phcode-dev phoenix-desktop)"
    appNewVersion="$(versionFromGit phcode-dev phoenix-desktop)"
    expectedTeamID="8F632A866K"
    ;;

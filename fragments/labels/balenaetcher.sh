balenaetcher)
    name="balenaEtcher"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="balenaEtcher-[0-9.]*-arm64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="balenaEtcher-[0-9.]*-x64.dmg"
    fi
    downloadURL="$(downloadURLFromGit balena-io etcher)"
    appNewVersion="$(versionFromGit balena-io etcher)"
    expectedTeamID="66H43P8FRG"
    ;;

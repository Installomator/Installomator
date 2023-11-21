franz)
    name="Franz"
    type="dmg"
    if [[ $(arch) = "arm64" ]]; then
        archiveName="Franz-[0-9.]*-arm64.dmg" 
    else 
        archiveName="Franz-[0-9.]*.dmg" 
    fi
    downloadURL="$(downloadURLFromGit meetfranz franz)"
    appNewVersion="$(versionFromGit meetfranz franz)"
    expectedTeamID="TAC9P63ANZ"
    ;;


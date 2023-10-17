clipgrab)
    name="ClipGrab"
    type="dmg"
    expectedTeamID="E8BJ3ZV5W8"
    downloadURL="$( curl -s 'https://clipgrab.org' | tr '"' '\n' | grep dmg )"
    appNewVersion="$( echo "$downloadURL" | cut -d '-' -f 2 )"
    ;;

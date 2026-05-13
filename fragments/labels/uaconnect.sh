uaconnect)
    name="UA Connect"
    type="dmg"
    downloadURL="https://www.uaudio.com/apps/uaconnect/mac/installer"
    appNewVersion="$(curl -Ifs "$downloadURL" | grep 'location:' | cut -d'_' -f4-6 | tr '_' '.')"
    expectedTeamID="4KAC9AX6CG"
    ;;

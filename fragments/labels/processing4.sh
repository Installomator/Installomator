processing4)
    name="Processing"
    type="dmg"
    archiveName="Processing-[0-9.]*-macOS-$( if [ "$( arch )" = "arm64" ]; then echo "aarch64" ; else echo "x64" ; fi ).dmg"
    downloadURL=$(downloadURLFromGit processing processing4)
    appNewVersion="$( echo "$downloadURL" | awk -F '-' '{ print $4 }' )"
    expectedTeamID="6297K33652"
    ;;

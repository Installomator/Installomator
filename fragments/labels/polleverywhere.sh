polleverywhere)
    name="Poll Everywhere"
    type="dmg"
    downloadURL="$(curl -fs https://www.polleverywhere.com/app/releases/mac | grep -i mac-stable | grep -o -i -E "https.*" | cut -d '"' -f1 | head -n 1)"
    appNewVersion="$(echo $downloadURL | cut -d "/" -f5)"
    expectedTeamID="W48F3X5M8W"
    ;;

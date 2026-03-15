overflow)
    name="Overflow"
    type="dmg"
    downloadURL="$(curl -LsS https://overflow.io/download/ | grep -oE 'https://[^"]+\.dmg'))"
    appNewVersion=$(echo "$downloadURL" | awk -F '-|[.]dmg' '{ print $(NF-1) }')
    expectedTeamID="7TK7YSGJFF"
    versionKey="CFBundleShortVersionString"
    ;;

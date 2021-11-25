overflow)
    name="Overflow"
    type="dmg"
    downloadURL="$(curl -sL 'https://overflow.io/download/' | awk -F '"' '/app-updates.overflow.io\/packages\/updates\/osx_64/ { print $8; exit }')"
    appNewVersion=$(echo "$downloadURL" | awk -F '-|[.]dmg' '{ print $(NF-1) }')
    expectedTeamID="7TK7YSGJFF"
    versionKey="CFBundleShortVersionString"
    ;;

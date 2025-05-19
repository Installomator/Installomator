descript)
    name="Descript"
    type="dmg"
    downloadURL=$(curl -fsL "https://web.descript.com/download?platform=mac" -w "%{url_effective}" -o /dev/null)
    appNewVersion=$(echo "$downloadURL" | sed -nE 's/.*Descript-([0-9.]+-release\.[0-9.]+)\.dmg/\1/p')
    expectedTeamID="D4CJQGP2T7"
    ;;
    
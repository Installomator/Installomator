alfred)
    name="Alfred"
    type="dmg"
    downloadURL=$(curl -fsL "https://www.alfredapp.com/" | grep -Eo 'https://cachefly\.alfredapp\.com/Alfred_[0-9]+(\.[0-9]+)+_[0-9]+\.dmg' | sed -n '1p')
    appNewVersion=$(printf '%s\n' "$downloadURL" | sed -nE 's#^.*/Alfred_([0-9]+(\.[0-9]+)+)_[0-9]+\.dmg$#\1#p')
    appName="Alfred ${appNewVersion%%.*}.app"
    expectedTeamID="XZZXE9SED4"
    ;;

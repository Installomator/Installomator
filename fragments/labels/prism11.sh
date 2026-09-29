prism11)
    name="Prism 11"
    type="dmg"
    sparkleData=$(curl -fsL "https://licenses.graphpad.com/updates?version=11.0.0&configuration=full&platform=Mac&osVersion=26.0.0&osBitVersion=arm&appLanguageCode=en-us")
    downloadURL=$(echo "$sparkleData" | xmllint --xpath 'string(//*[local-name()="enclosure"]/@url)' -)
    appNewVersion=$(echo "$downloadURL" | sed -E 's|.*/prism/11/([0-9]+(\.[0-9]+)+)/InstallPrism11\.dmg|\1|')
    expectedTeamID="YQ2D36NS9M"
    ;;

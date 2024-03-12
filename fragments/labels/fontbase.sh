fontbase)
    name="FontBase"
    type="dmg"
    appNewVersion=$(curl -s https://releases.fontba.se/mac/latest-mac.yml | grep version: | awk -F ':' '{print $2}' | sed -e 's/^ *//' -e 's/ *$//')
    downloadURL="https://releases.fontba.se/mac/FontBase-$appNewVersion.dmg"
    expectedTeamID="457B89RFCZ"
    ;;

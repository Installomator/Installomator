cardpresso)
    name="cardpresso"
    type="dmg"
    appNewVersion=$(curl -is "https://formulae.brew.sh/cask/cardpresso" | grep 'Current version:' | grep -oie "[0-9\.]*\.dmg" | awk -F ".dmg" '{print $1}')
    downloadURL="https://www.cardpresso.com/downloads/cardpresso_releases/for_mac_osx/cardPresso${appNewVersion}.dmg"
    expectedTeamID="QH48YJ244W"
    ;;

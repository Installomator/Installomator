connectfonts)
    name="Connect Fonts"
    type="dmg"
    downloadURL="https://links.extensis.com/connect_fonts/cf_latest?language=en&platform=mac"
    appNewVersion=$( curl -is "$downloadURL" | grep "location:" | grep -o "[[:digit:]]\+-[[:digit:]]\+-[[:digit:]]\+" | sed -e 's/-/./g' )
    expectedTeamID="J6MMHGD9D6"
    ;;

extensisconnect)
    name="Extensis Connect"
    type="dmg"
    downloadURL="https://links.extensis.com/extensis_connect/ec_latest?language=en&platform=mac"
    appNewVersion=$( curl -is "$downloadURL" | grep "location:" | grep -o "[[:digit:]]\+-[[:digit:]]\+-[[:digit:]]\+" | sed -e 's/-/./g' )
    expectedTeamID="J6MMHGD9D6"
    ;;
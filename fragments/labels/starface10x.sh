starface10x)
    name="STARFACE"
    type="dmg"
    downloadURL=$(curl -fs "https://www.starface-cdn.de/starface/clients/mac/appcast.xml" | grep -i 'enclosure ' | grep -i 'url=' | grep -m 1 -F 'shortVersionString="10.' | cut -d '"' -f 10)
    appNewVersion=$(curl -fs "https://www.starface-cdn.de/starface/clients/mac/appcast.xml" | grep -i 'enclosure ' | grep -i 'url=' | grep -m 1 -F 'shortVersionString="10.' | cut -d '"' -f 4)
    expectedTeamID="Q965D3UXEW"
    ;;

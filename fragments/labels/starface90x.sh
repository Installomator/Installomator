starface90x)
    name="STARFACE"
    # Downloads the latest 9.0.x version of the STARFACE Client. The client depends on the version of the PBX, so the correct version should be selected for installation
    type="dmg"
    downloadURL=$(curl -fs "https://www.starface-cdn.de/starface/clients/mac/appcast.xml" | grep -i 'enclosure ' | grep -i 'url=' | grep -m 1 "9.0" | cut -d '"' -f 10)
    appNewVersion=$(curl -fs "https://www.starface-cdn.de/starface/clients/mac/appcast.xml" | grep -i 'enclosure ' | grep -i 'url=' | grep -m 1 "9.0" | cut -d '"' -f 4)
    expectedTeamID="Q965D3UXEW"
    versionKey="CFBundleVersion"
    ;;

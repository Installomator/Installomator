starface81x)
    name="STARFACE"
    # Downloads the latest 8.1.x version of the STARFACE Client. The client depends on the version of the PBX, so the correct version should be selected for installation
    type="dmg"
    downloadURL=$(curl -fs "https://www.starface-cdn.de/starface/clients/mac/appcast.xml" | grep -i 'enclosure' | grep -m 1 "8.1" | sed 's/.*url\(.*\).dmg/\1/' | cut -d '"' -f 2)
    appNewVersion=$(curl -fs "https://www.starface-cdn.de/starface/clients/mac/appcast.xml" | grep -i 'enclosure' | grep -m 1 "8.1" | sed 's/.*sparkle:version\(.*\) type/\1/' | cut -d '"' -f 2)
    expectedTeamID="Q965D3UXEW"
    versionKey="CFBundleVersion"
    ;;

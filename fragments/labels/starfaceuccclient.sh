starfaceuccclient)
    name="STARFACE UCC Client"
    # Downloads the latest 6.7.x version of the STARFACE Client. The client depends on the version of the PBX, so the correct version should be selected for installation
    type="zip"
    downloadURL=$(curl -fs "https://www.starface-cdn.de/starface/clients/mac/appcast.xml" | grep -i 'enclosure url=' | grep -m 1 "STARFACE_UCC_Client_6.7" | cut -d '"' -f 2)
    appNewVersion=$(curl -fs "https://www.starface-cdn.de/starface/clients/mac/appcast.xml" | grep -i 'enclosure url=' | grep -m 1 "STARFACE_UCC_Client_6.7" | cut -d '"' -f 2 | sed -e 's/.*-\(.*\).zip*/\1/')
    expectedTeamID="Q965D3UXEW"
    versionKey="CFBundleVersion"
    ;;

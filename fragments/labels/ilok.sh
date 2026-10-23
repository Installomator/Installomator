ilok)
    name="iLok License Manager"
    type="pkgInDmgInZip"
    downloadURL="https://installers.ilok.com/iloklicensemanager/LicenseSupportInstallerMac.zip"
    appNewVersion=$(curl -fs "https://updates.ilok.com/iloklicensemanager/LicenseSupportInstallerMacAppcast.xml" | xpath 'string(//rss/channel/item/enclosure/@sparkle:shortVersionString)' 2>/dev/null | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')
    expectedTeamID="TFZ8226T6X"
    ;;

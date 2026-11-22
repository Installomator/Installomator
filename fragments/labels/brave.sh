brave)
    name="Brave Browser"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        sparkleData=$(curl -fsL "https://updates.bravesoftware.com/sparkle/Brave-Browser/stable-arm64/appcast.xml")
    else
        sparkleData=$(curl -fsL "https://updates.bravesoftware.com/sparkle/Brave-Browser/stable/appcast.xml")
    fi
    appNewVersion=$(echo "$sparkleData" | xpath 'string((//*[local-name()="item"])[1]/enclosure/@*[local-name()="shortVersionString"])' | cut -d. -f1-3)
    downloadURL=$(echo "$sparkleData" | xpath 'string((//*[local-name()="item"])[1]/enclosure/@url)')
    appCustomVersion() { defaults read "/Applications/Brave Browser.app/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null | cut -d. -f2- }
    expectedTeamID="KL8N8XSYF4"
    ;;

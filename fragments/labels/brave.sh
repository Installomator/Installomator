brave)
    name="Brave Browser"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        sparkleFeed="https://updates.bravesoftware.com/sparkle/Brave-Browser/stable-arm64/appcast.xml"
    else
        sparkleFeed="https://updates.bravesoftware.com/sparkle/Brave-Browser/stable/appcast.xml"
    fi
    sparkleData=$(curl -fsL "$sparkleFeed")
    downloadURL=$(xmllint --xpath 'string((//*[local-name()="item"])[1]/enclosure/@url)' - <<< "$sparkleData")
    appNewVersion=$(xmllint --xpath 'string((//*[local-name()="item"])[1]/enclosure/@*[local-name()="shortVersionString"])' - <<< "$sparkleData" | cut -d. -f1-3)
    appCustomVersion() { defaults read "/Applications/Brave Browser.app/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null | cut -d. -f2- }
    expectedTeamID="KL8N8XSYF4"
    ;;

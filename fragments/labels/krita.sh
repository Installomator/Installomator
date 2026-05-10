krita)
    name="krita"
    type="dmg"
    kritaXML=$(curl -fsL "https://apps.kde.org/en-gb/krita/index.xml")
    downloadURL=$(echo "$kritaXML" | xpath "string(//a[contains(@href, 'signed.dmg')]/@href")
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)-.*/\1/g')
    expectedTeamID="DL93766A3G"
    ;;

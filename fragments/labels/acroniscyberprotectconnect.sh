acroniscyberprotectconnect|\
remotix)
    name="Acronis Cyber Protect Connect"
    type="dmg"
    downloadURL="https://go.acronis.com/AcronisCyberProtectConnect_ForMac"
    versionKey="CFBundleVersion"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i "^location" | sed -E 's/.*\/[a-zA-Z]*-[0-9.]*-([0-9.]*)\.dmg/\1/g')
    expectedTeamID="ZU2TV78AA6"
    ;;

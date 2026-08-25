omnigraffle6)
    name="OmniGraffle"
    type="dmg"
    downloadURL=$(curl -fs "https://update.omnigroup.com/appcast/com.omnigroup.OmniGraffle6" | xmllint --xpath '(//rss/channel/item/enclosure/@url)[1]' --nowarning - 2>/dev/null | cut -d '"' -f 2)
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]+-([0-9.]+)\..*/\1/')
    expectedTeamID="Group"
    acceptEULA="yes"
    ;;

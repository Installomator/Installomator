obs)
    name="OBS"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        SUFeedURL="https://obsproject.com/osx_update/updates_arm64_v2.xml"
    elif [[ $(arch) == "i386" ]]; then
        SUFeedURL="https://obsproject.com/osx_update/updates_x86_64_v2.xml"
    fi
    appNewVersion=$(curl -fs "$SUFeedURL" | xpath '(//rss/channel/item[sparkle:channel="stable"]/sparkle:shortVersionString/text())[1]' 2>/dev/null)
    downloadURL=$(curl -fs "$SUFeedURL" | xpath 'string(//rss/channel/item[sparkle:channel="stable"]/enclosure/@url[1])' 2>/dev/null)
    archiveName=$(basename "$downloadURL")   
    versionKey="CFBundleShortVersionString"
    blockingProcesses=( "OBS Studio" )
    expectedTeamID="2MMRE5MTB8"
    ;;

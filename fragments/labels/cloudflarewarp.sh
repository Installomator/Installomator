cloudflarewarp)
    name="Cloudflare_WARP"
    type="pkg"
    appName="Cloudflare WARP.app"
    cloudflareFeed="$(curl -fsL "https://downloads.cloudflareclient.com/v1/update/sparkle/macos/ga")"
    downloadURL="$(echo "${cloudflareFeed}" | xpath 'string((//rss/channel/item)[1]/enclosure/@url)' 2>/dev/null)"
    appNewVersion="$(echo "${cloudflareFeed}" | xpath 'string((//rss/channel/item)[1]/sparkle:shortVersionString)' 2>/dev/null)"
    expectedTeamID="68WVV388M8"
    blockingProcesses=( NONE )
    ;;

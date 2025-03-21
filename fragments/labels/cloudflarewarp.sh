cloudflarewarp)
    name="Cloudflare_WARP"
    type="pkg"
    packageID="com.cloudflare.1dot1dot1dot1.macos"
    downloadURL="https://1111-releases.cloudflareclient.com/mac/latest"
    appNewVersion="$(curl -SLI ${downloadURL} | grep -i "^location.*version" | awk -F "version/" '{print$2}' | awk -F "." '{print$1"."$2"."$3}')"
    expectedTeamID="68WVV388M8"
    ;;

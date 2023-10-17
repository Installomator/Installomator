vmwarefusion)
    name="VMware Fusion"
    type="dmg"
    downloadURL="https://www.vmware.com/go/getfusion"
    curlOptions=(-H "Accept: */*" -H "Accept-Encoding: gzip, deflate" -H "Connection: keep-alive" -H "Host: www.vmware.com" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15")
    appNewVersion=$(curl -fsIL ${curlOptions} "https://www.vmware.com/go/getfusion" | grep -i "^location" | awk '{print $2}' | sed 's/.*-\(.*\)-.*/\1/')
    expectedTeamID="EG7KH642X6"
    ;;

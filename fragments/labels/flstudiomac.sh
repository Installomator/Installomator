flstudiomac)
    name="FL Studio"
    appName="FL Studio 2025.app"
    type="pkgInDmg"
    downloadURL="https://support.image-line.com/redirect/flstudio_mac_installer"
    curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Safari/605.1.15" )
    appNewVersion=$(curl -fsIL "https://support.image-line.com/redirect/flstudio_mac_installer" | grep -i ^location | tail -1 | sed 's/.*flstudio_mac_\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\)\.dmg.*/\1/')
    expectedTeamID="N68WEP5ZZZ"
    ;;

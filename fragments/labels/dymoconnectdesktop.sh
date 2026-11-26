dymoconnectdesktop)
    name="DYMO Connect"
    type="pkg"
    dymoCurlOptions=(--http1.1 --compressed -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8" -H "Accept-Language: en-US,en;q=0.9" -H "Cache-Control: no-cache" -H "Upgrade-Insecure-Requests: 1")
    dymoData=$(curl -fsL "${dymoCurlOptions[@]}" "https://www.dymo.com/support?cfid=online-support") || cleanupAndExit 14 "Could not retrieve DYMO Connect release information." ERROR
    if [[ $(arch) == "arm64" ]]; then
        dymoArchitecture="Arm64"
    elif [[ $(arch) == "i386" ]]; then
        dymoArchitecture="X64"
    else
        cleanupAndExit 95 "Unsupported architecture for DYMO Connect." ERROR
    fi
    downloadURL=$(printf '%s\n' "$dymoData" | grep -Eo "https://dymoreleasecontent\\.blob\\.core\\.windows\\.net/dymo-release/DCDMAC/DCDMac[0-9]+(\\.[0-9]+)+-${dymoArchitecture}\\.pkg" | head -1)
    appNewVersion=$(printf '%s\n' "$downloadURL" | sed -E "s#.*/DCDMac([0-9]+(\\.[0-9]+)+)-${dymoArchitecture}\\.pkg#\\1#")
    [[ -n "$downloadURL" && "$appNewVersion" =~ ^[0-9]+(\.[0-9]+)+$ ]] || cleanupAndExit 14 "Could not determine the DYMO Connect download." ERROR
    expectedTeamID="N3S6676K3E"
    ;;

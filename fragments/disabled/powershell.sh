
powershell)
    #NOTE: powershell installers are not notarized
    # credit: Tadayuki Onishi (@kenchan0130)
    name="PowerShell"
    type="pkg"
    downloadURL=$(curl -fs "https://api.github.com/repos/Powershell/Powershell/releases/latest" \
    | awk -F '"' '/browser_download_url/ && /pkg/ { print $4 }' | grep -v lts )
    expectedTeamID="UBF8T346G9"
    ;;

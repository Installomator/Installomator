antigravity)
    name="Antigravity"
    type="dmg"
    antigravityDownloadPage=$(curl -fsL --compressed "https://antigravity.google/download")
    if [[ $(arch) == "arm64" ]]; then
        antigravityArch="darwin-arm"
    else
        antigravityArch="darwin-x64"
    fi
    downloadURL=$(echo "$antigravityDownloadPage" | grep -Eo "https://storage\\.googleapis\\.com/antigravity-public/antigravity-hub/[0-9]+(\\.[0-9]+)+-[0-9]+/${antigravityArch}/Antigravity\\.dmg" | head -n 1)
    appNewVersion=$(echo "$downloadURL" | sed -E 's#.*/antigravity-hub/([0-9]+(\.[0-9]+)+)-[0-9]+/darwin-.*/Antigravity\.dmg$#\1#')
    expectedTeamID="EQHXZ8M8AV"
    ;;

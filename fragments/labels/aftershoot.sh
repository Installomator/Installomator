aftershoot)
    name="Aftershoot"
    type="dmg"
    aftershootDownloadPage=$(curl -fsL -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15" "https://aftershoot.com/download/")
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(echo "$aftershootDownloadPage" | grep -oE 'https://download\.aftershoot\.com/production/aarch64-macos/AfterShoot-mac-latest-[0-9.]+\.dmg' | head -1)
    else
        downloadURL=$(echo "$aftershootDownloadPage" | grep -oE 'https://download\.aftershoot\.com/production/x86_64-macos/AfterShoot-mac-latest-[0-9.]+\.dmg' | head -1)
    fi
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*AfterShoot-mac-latest-([0-9.]+)\.dmg/\1/')
    expectedTeamID="FQN3S7ZG69"
    ;;

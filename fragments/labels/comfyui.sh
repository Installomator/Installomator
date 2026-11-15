comfyui)
    name="Comfy Desktop"
    type="dmg"
    if [[ $(arch) != "arm64" ]]; then
        cleanupAndExit 95 "Comfy Desktop is only available for Apple Silicon" ERROR
    fi
    comfyFeed=$(curl -fsL "https://download.todesktop.com/241012ess7yxs0e/latest-mac.yml")
    appNewVersion=$(echo "${comfyFeed}" | awk '/^version:/{print $2; exit}')
    comfyDmg=$(echo "${comfyFeed}" | awk -F'url: ' '/url:.*\.dmg/{print $2; exit}' | tr -d '\r')
    downloadURL="https://download.todesktop.com/241012ess7yxs0e/${comfyDmg// /%20}"
    expectedTeamID="6FXBT88W8J"
    ;;

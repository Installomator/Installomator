comet)
    name="Comet"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -fsL -r 0-0 -o /dev/null -w "%{url_effective}" "https://www.perplexity.ai/rest/browser/download?channel=stable&platform=mac_arm64")
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -fsL -r 0-0 -o /dev/null -w "%{url_effective}" "https://www.perplexity.ai/rest/browser/download?channel=stable&platform=mac_x64")
    fi
    appNewVersion=$(echo "$downloadURL" | cut -d "/" -f4)
    expectedTeamID="7S8W4W365S"
    ;;

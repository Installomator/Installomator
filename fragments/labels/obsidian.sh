obsidian)
    # credit: Søren Theilgaard (@theilgaard)
    name="Obsidian"
    type="dmg"
    downloadURL=$(curl -sfL --connect-timeout 10 --max-time 30 "https://api.github.com/repos/obsidianmd/obsidian-releases/releases?per_page=10" | awk -F '"' '/browser_download_url/ && /\.dmg"/ { print $4; exit }')
    appNewVersion=$(echo "$downloadURL" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    expectedTeamID="6JSW4SJWN9"
    ;;

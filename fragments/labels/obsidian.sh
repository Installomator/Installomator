obsidian)
    name="Obsidian"
    type="dmg"
    obsidianData=$(curl -fsL "https://raw.githubusercontent.com/obsidianmd/obsidian-releases/master/desktop-releases.json")
    appNewVersion=$(getJSONValue "$obsidianData" "latestVersion")
    downloadURL="https://github.com/obsidianmd/obsidian-releases/releases/download/v${appNewVersion}/Obsidian-${appNewVersion}.dmg"
    expectedTeamID="6JSW4SJWN9"
    ;;

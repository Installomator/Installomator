obsidian)
name="Obsidian"
    type="dmg"
    appNewVersion=$(curl -sfL --connect-timeout 10 --max-time 30 "https://raw.githubusercontent.com/obsidianmd/obsidian-releases/master/desktop-releases.json" | awk -F'"' '/"beta"/{exit} /"latestVersion"/{print $4; exit}')
    downloadURL="https://github.com/obsidianmd/obsidian-releases/releases/download/v${appNewVersion}/Obsidian-${appNewVersion}.dmg"
    expectedTeamID="6JSW4SJWN9"
    ;;

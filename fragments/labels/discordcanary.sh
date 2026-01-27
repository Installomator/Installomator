discordcanary)
    name="Discord Canary"
    type="dmg"
    downloadURL="https://discord.com/api/download/canary?platform=osx"
    appNewVersion="$(curl -fsL -o /dev/null -w %{url_effective} "${downloadURL}" | awk -F'/' '{print $(NF-1)}')"
    expectedTeamID="53Q6R32WPB"
    ;;
    

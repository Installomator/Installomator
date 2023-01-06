renew-noagent)
    #Renew by @BigMacAdmin and Second Son Consulting
    name="Renew-NoAgent"
    type="pkg"
    archiveName="Renew_NoAgent_v[0-9.]*.pkg"
    downloadURL=$(downloadURLFromGit secondsonconsulting Renew )
    appNewVersion=$(versionFromGit secondsonconsulting Renew )
    appCustomVersion() { grep -i "scriptVersion=" /usr/local/Renew.sh | cut -d '"' -f2 }
    expectedTeamID="7Q6XP5698G"
    ;;

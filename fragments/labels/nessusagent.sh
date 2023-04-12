nessusagent)
    name="Nessus Agent"
    type="pkgInDmg"
    downloadURL="https://www.tenable.com/downloads/api/v2/pages/nessus-agents/files/NessusAgent-latest.dmg"
    appCustomVersion() { /Library/NessusAgent/run/bin/nasl -v | grep Agent | cut -d' ' -f3 }
    appNewVersion=$(curl -I -s  'https://www.tenable.com/downloads/api/v2/pages/nessus-agents/files/NessusAgent-latest.dmg' | grep 'filename=' | cut -d- -f3 | cut -f 1-3 -d '.')
    expectedTeamID="4B8J598M7U"
    ;;

nessusagent)
    name="Nessus Agent"
    type="pkgInDmg"
    downloadURL="https://www.tenable.com/downloads/api/v1/public/pages/nessus-agents/downloads/18063/download?i_agree_to_tenable_license_agreement=true"
    appCustomVersion() { /Library/NessusAgent/run/bin/nasl -v | grep Agent | cut -d' ' -f3 }
    appNewVersion=$(curl -I  'https://www.tenable.com/downloads/api/v1/public/pages/nessus-agents/downloads/18063/download?i_agree_to_tenable_license_agreement=true' | grep 'filename=' | cut -d- -f3 | cut -f 1-3 -d '.')
    expectedTeamID="4B8J598M7U"
    ;;

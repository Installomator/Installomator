bitwarden)
    name="Bitwarden"
    type="dmg"
    appNewVersion=$(curl -s "https://github.com/bitwarden/clients/releases?q\=desktop" | xmllint --html --xpath 'substring-after(string(//h2[starts-with(text(),"Desktop v")]), " v")' - 2>/dev/null)
    downloadURL="https://github.com/bitwarden/clients/releases/download/desktop-v${appNewVersion}/Bitwarden-${appNewVersion}-universal.dmg"
    expectedTeamID="LTZ2PFU5D6"
    ;;

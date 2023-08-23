tunnelblick)
    name="Tunnelblick"
    type="dmg"
    downloadURL=$(downloadURLFromGit TunnelBlick Tunnelblick )
    appNewVersion=$(curl -fsL "https://github.com/Tunnelblick/Tunnelblick/releases/latest" | xmllint --html --xpath 'substring-after(string(//h1[@class="d-inline mr-3"]), "Tunnelblick ")'  - 2> /dev/null)
    expectedTeamID="Z2SG5H3HC8"
    ;;

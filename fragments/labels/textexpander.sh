textexpander)
    name="TextExpander"
    type="dmg"
    downloadURL="https://textexpander.com/cgi-bin/redirect.pl?cmd=download&platform=osx"
    appNewVersion=$( curl -fsIL "https://textexpander.com/cgi-bin/redirect.pl?cmd=download&platform=osx" | grep -i "^location" | awk '{print $2}' | tail -1 | cut -d "_" -f2 | sed -nre 's/^[^0-9]*(([0-9]+\.)*[0-9]+).*/\1/p' )
    expectedTeamID="7PKJ6G4DXL"
    ;;

grandperspective)
    name="GrandPerspective"
    type="dmg"
    downloadURL="https://sourceforge.net/projects/grandperspectiv/files/latest/download"
    appNewVersion=$(curl -s https://sourceforge.net/projects/grandperspectiv/files/grandperspective/ | grep -A1 'Click to enter' | head -1 | sed -nre 's/^[^0-9]*(([0-9]+\.)*[0-9]+).*/\1/p')
    expectedTeamID="3Z75QZGN66"
    ;;

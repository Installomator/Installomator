typora)
    name="Typora"
    type="dmg"
    downloadURL="https://www.typora.io/download/Typora.dmg"
    appNewVersion="$(curl -fs "https://www.typora.io/dev_release.html" | grep -o -i "h4>[0-9.]*</h4" | head -1 | sed -E 's/.*h4>([0-9.]*)<\/h4.*/\1/')"
    expectedTeamID="9HWK5273G4"
    ;;

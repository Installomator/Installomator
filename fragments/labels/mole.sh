mole)
    name="Mole"
    type="dmg"
    downloadURL="https://mole.fit/download"
    appNewVersion=$(curl -fsL -r 0-0 -o /dev/null -w '%{url_effective}' "$downloadURL" | sed -E 's#^.*/Mole-([0-9]+(\.[0-9]+)+)\.dmg$#\1#')
    expectedTeamID="5EH69Y5X38"
    ;;

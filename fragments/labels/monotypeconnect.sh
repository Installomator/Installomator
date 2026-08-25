monotypeconnect)
    name="Monotype Connect"
    type="dmg"
    downloadURL="https://links.extensis.com/extensis_connect/ec_latest?language=en&platform=mac"
    appNewVersion=$(curl -fsS -D - -o /dev/null "$downloadURL" | awk 'BEGIN{IGNORECASE=1}/^location:/{gsub("\r",""); print $2}' | tail -n 1 | sed -E 's|.*/ExtensisConnect-M-([0-9]+)-([0-9]+)-([0-9]+)\.dmg$|\1.\2.\3|')
    expectedTeamID="J6MMHGD9D6"
    ;;

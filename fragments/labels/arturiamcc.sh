arturiamcc)
    name="MIDI Control Center"
    type="pkg"
    arturiaDetails="$(curl -fsL 'https://www.arturia.com/api/resources?slugs=mccu&types=soft')"
    arturiaCount=0
    maxEntries=$(getJSONValue "$arturiaDetails" "length" 2>/dev/null)
    downloadURL=""
    appNewVersion=""
    while [[ $arturiaCount -lt $maxEntries ]]; do
        arturiaPlatform=$(getJSONValue "$arturiaDetails" "[$arturiaCount].platform_type" 2>/dev/null)
        if [[ $arturiaPlatform == "mac" ]]; then
            downloadURL=$(getJSONValue "$arturiaDetails" "[$arturiaCount].permalink")
            appNewVersion=$(getJSONValue "$arturiaDetails" "[$arturiaCount].version")
            break
        fi
        arturiaCount=$((arturiaCount + 1))
    done
    expectedTeamID="T53ZHSF36C"
;;

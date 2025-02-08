arturiamcc)
    name="MIDI Control Center"
    type="pkg"
    arturiaDetails="$(curl -fsL 'https://www.arturia.com/api/resources?slugs=mccu&types=soft')"
    arturiaCount=0
    maxEntries=$(getJSONValue "$arturiaDetails" "length" 2>/dev/null) # Get the number of entries
    downloadURL=""
    appNewVersion=""
    while [[ $arturiaCount -lt $maxEntries ]]; do
        arturiaPlatform=$(getJSONValue "$arturiaDetails" "[$arturiaCount].platform_type" 2>/dev/null)
        if [[ $arturiaPlatform == "mac" ]]; then
            # Extract the permalink and version for macOS
            downloadURL=$(getJSONValue "$arturiaDetails" "[$arturiaCount].permalink")
            appNewVersion=$(getJSONValue "$arturiaDetails" "[$arturiaCount].version")
            break
        fi
        arturiaCount=$((arturiaCount + 1))
    done
    expectedTeamID="T53ZHSF36C"
;;

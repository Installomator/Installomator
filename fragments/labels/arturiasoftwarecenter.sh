arturiasoftwarecenter)
    name="Arturia Software Center"
    type="pkg"
    packageID="com.Arturia.ArturiaSoftwareCenter.resources"
    versionKey="CFBundleVersion"
    arturiaDetails="$(curl -fsL 'https://www.arturia.com/api/resources?slugs=asc&types=soft')"
    arturiaCount=0
    while [[ -z $arturiaMatch ]]
    do
        arturiaPlatform=$(getJSONValue "$arturiaDetails" "[$arturiaCount].platform_type" 2>/dev/null)
        if [ $? -eq 1 ]; then
         downloadURL=""
            appNewVersion=""
            break
        elif [[ $arturiaPlatform == "mac" ]]; then
            downloadURL=$(getJSONValue "$arturiaDetails" "[$arturiaCount].permalink")
            appNewVersion="$(getJSONValue "$arturiaDetails" "[$arturiaCount].version")"
            break
        fi
        arturiaCount=$(( $arturiaCount + 1 ))
    done
    expectedTeamID="T53ZHSF36C"
    ;;

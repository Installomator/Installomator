thunderbirdesr_intl)
    # This label will try to figure out the selected language of the user,
    # and install corrosponding version of Thunderbird ESR
    name="Thunderbird"
    type="dmg"
    userLanguage=$(
        if [[ -e "/Applications/${name}.app/Contents/Resources/locale.ini" ]]; then
            tail -1 "/Applications/${name}.app/Contents/Resources/locale.ini" | grep "locale=" | awk -F'=' '{ print $2 }'
        elif [[ -d "/Applications/${name}.app/Contents/Resources/sv.lproj" ]]; then
            echo "sv-SE"
        elif [[ -d "/Applications/${name}.app/Contents/Resources/en.lproj" ]]; then
            echo "en-GB"
        else
            macOSLanguage=$(runAsUser defaults read -g AppleLanguages | head -n 2 | tail -n 1 | sed 's/[", ]//g')

            if [[ "$macOSLanguage" == en-* ]]; then
                # If the language is English but not US or GB, default to en-GB
                [[ "$macOSLanguage" != "en-US" && "$macOSLanguage" != "en-GB" ]] && macOSLanguage="en-GB"
            fi

            echo "$macOSLanguage"
        fi
    )
    echo "Found language $userLanguage to be used for $name."
    releaseURL="https://ftp.mozilla.org/pub/thunderbird/releases/latest/README.txt"
    until curl -fs $releaseURL | grep -q "=$userLanguage"; do
        if [ ${#userLanguage} -eq 2 ]; then
            break
        fi
        echo "No locale matching '$userLanguage', trying '${userLanguage:0:2}'"
        userLanguage=${userLanguage:0:2}
    done
    echo "Using language '$userLanguage' for download."
    thunderbirdVersions=$(curl -fs "https://product-details.mozilla.org/1.0/thunderbird_versions.json")
    appNewVersion=$(getJSONValue "$thunderbirdVersions" "THUNDERBIRD_ESR" | tr -d esr)
    downloadURL="https://ftp.mozilla.org/pub/thunderbird/releases/${appNewVersion}esr/mac/${userLanguage}/$(curl -fs "https://ftp.mozilla.org/pub/thunderbird/releases/${appNewVersion}esr/mac/${userLanguage}/" | grep dmg | sed -n 's/.*href="\([^"]*\)".*/\1/p' | awk -F'/' '{ print $(NF)}' | sed 's/ /%20/g')"
    if ! curl -sfL --output /dev/null -r 0-0 $downloadURL; then
        printlog "Download not found for '$userLanguage', using default ('en-GB')."
        downloadURL="https://ftp.mozilla.org/pub/thunderbird/releases/${appNewVersion}esr/mac/en-GB/$(curl -fs "https://ftp.mozilla.org/pub/thunderbird/releases/${appNewVersion}esr/mac/en-GB/" | grep dmg | sed -n 's/.*href="\([^"]*\)".*/\1/p' | awk -F'/' '{ print $(NF)}')"
    fi
    expectedTeamID="43AQ936H96"
    blockingProcesses=( thunderbird )
    ;;

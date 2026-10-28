firefoxesr_next_intl)
    name="Firefox"
    type="dmg"
    userLanguage=$(runAsUser defaults read .GlobalPreferences AppleLocale | tr '_' '-')
    printlog "Found language $userLanguage to be used for $name."
    releaseURL="https://ftp.mozilla.org/pub/firefox/releases/latest-esr/README.txt"
    until curl -fs "$releaseURL" | grep -q "=$userLanguage"; do
        if [[ ${#userLanguage} -eq 2 ]]; then
            break
        fi
        printlog "No locale matching '$userLanguage', trying '${userLanguage:0:2}'"
        userLanguage=${userLanguage:0:2}
    done
    printlog "Using language '$userLanguage' for download."
    downloadURL="https://download.mozilla.org/?product=firefox-esr-next-latest-ssl&os=osx&lang=$userLanguage"
    if ! curl -sfL --output /dev/null -r 0-0 "$downloadURL"; then
        printlog "Download not found for '$userLanguage', using default ('en-US')."
        downloadURL="https://download.mozilla.org/?product=firefox-esr-next-latest-ssl&os=osx"
    fi
    firefoxVersions=$(curl -fs "https://product-details.mozilla.org/1.0/firefox_versions.json")
    appNewVersion=$(getJSONValue "$firefoxVersions" "FIREFOX_ESR_NEXT" | sed 's/esr$//')
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    ;;

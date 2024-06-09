firefoxpkg_intl)
    # This label will try to figure out the selected language of the user,
    # and install corrosponding version of Firefox ESR
    name="Firefox"
    type="pkg"
    userLanguage=$(runAsUser defaults read .GlobalPreferences AppleLocale | tr '_' '-' | cut -f1 -d"@")
    # userLanguage="sv-SE" #for tests without international language setup
    printlog "Found language $userLanguage to be used for Firefox." WARN
    releaseURL="https://ftp.mozilla.org/pub/firefox/releases/latest/README.txt"
    until curl -fs $releaseURL | grep -q "=$userLanguage"; do
        if [ ${#userLanguage} -eq 2 ]; then
            break
        fi
        printlog "No locale matching '$userLanguage', trying '${userLanguage:0:2}'"
        userLanguage=${userLanguage:0:2}
    done
    printlog "Using language $userLanguage for download." WARN
    downloadURL="https://download.mozilla.org/?product=firefox-pkg-latest-ssl&os=osx&lang=$userLanguage"
    # https://download.mozilla.org/?product=firefox-pkg-latest-ssl&os=osx&lang=en-US
    if ! curl -sfL --output /dev/null -r 0-0 "$downloadURL" ; then
        printlog "Download not found for that language. Using en-US" WARN
        downloadURL="https://download.mozilla.org/?product=firefox-pkg-latest-ssl&os=osx&lang=en-US"
    fi
    firefoxVersions=$(curl -fs "https://product-details.mozilla.org/1.0/firefox_versions.json")
    appNewVersion=$(getJSONValue "$firefoxVersions" "LATEST_FIREFOX_VERSION")
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    ;;

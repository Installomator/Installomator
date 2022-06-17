firefoxpkg_intl)
    # This label will try to figure out the selected language of the user,
    # and install corrosponding version of Firefox ESR
    name="Firefox"
    type="pkg"
    userLanguage=$(runAsUser defaults read .GlobalPreferences AppleLocale)
    printlog "Found language $userLanguage to be used for Firefox." WARN
    if ! curl -fs "https://ftp.mozilla.org/pub/firefox/releases/latest/README.txt" | grep -o "=$userLanguage"; then
        userLanguage=$(echo $userLanguage | cut -c 1-2)
        if ! curl -fs "https://ftp.mozilla.org/pub/firefox/releases/latest/README.txt" | grep "=$userLanguage"; then
            userLanguage="en_US"
        fi
    fi
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

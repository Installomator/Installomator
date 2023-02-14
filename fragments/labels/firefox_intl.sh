firefox_intl)
    # This label will try to figure out the selected language of the user, 
    # and install corrosponding version of Firefox
    name="Firefox"
    type="dmg"
    userLanguage=$(runAsUser defaults read .GlobalPreferences AppleLocale)
    printlog "Found language $userLanguage to be used for Firefox."
    if ! curl -fs "https://ftp.mozilla.org/pub/firefox/releases/latest/README.txt" | grep -o "=$userLanguage"; then
        userLanguage=$(echo $userLanguage | cut -c 1-2)
        if ! curl -fs "https://ftp.mozilla.org/pub/firefox/releases/latest/README.txt" | grep "=$userLanguage"; then
            userLanguage="en_US"
        fi
    fi
    printlog "Using language $userLanguage for download."
    downloadURL="https://download.mozilla.org/?product=firefox-latest&amp;os=osx&amp;lang=$userLanguage"
    if ! curl -sfL --output /dev/null -r 0-0 "$downloadURL" ; then
        printlog "Download not found for that language. Using en-US"
        downloadURL="https://download.mozilla.org/?product=firefox-latest&os=osx&lang=en-US"
    fi
    appNewVersion=$(curl -fs https://www.mozilla.org/en-US/firefox/releases/ | grep '<html' | grep -o -i -e "data-latest-firefox=\"[0-9.]*\"" | cut -d '"' -f2)
    expectedTeamID="43AQ936H96"
    blockingProcesses=( firefox )
    ;;

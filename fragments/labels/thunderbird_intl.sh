thunderbird_intl)
    # This label will try to figure out the selected language of the user,
    # and install corrosponding version of Thunderbird
    name="Thunderbird"
    type="dmg"
    userLanguage=$(if [ -e "/Applications/${name}.app/Contents/Resources/locale.ini" ]; then tail -1 "/Applications/${name}.app/Contents/Resources/locale.ini" | grep "locale=" | awk -F'=' '{ print $2 }'; else runAsUser defaults read .GlobalPreferences AppleLocale | tr '_' '-'; fi)
    printlog "Found language $userLanguage to be used for $name."
    releaseURL="https://ftp.mozilla.org/pub/thunderbird/releases/latest/README.txt"
    until curl -fs $releaseURL | grep -q "=$userLanguage"; do
        if [ ${#userLanguage} -eq 2 ]; then
            break
        fi
        printlog "No locale matching '$userLanguage', trying '${userLanguage:0:2}'"
        userLanguage=${userLanguage:0:2}
    done
    printlog "Using language '$userLanguage' for download."
    downloadURL="https://download.mozilla.org/?product=thunderbird-latest&os=osx&lang=$userLanguage"
    if ! curl -sfL --output /dev/null -r 0-0 $downloadURL; then
        printlog "Download not found for '$userLanguage', using default ('en-US')."
        downloadURL="https://download.mozilla.org/?product=thunderbird-latest&os=osx"
    fi
    appNewVersion=$(curl -fsIL $downloadURL | awk -F releases/ '/Location:/ {split($2,a,"/"); print a[1]}')
    expectedTeamID="43AQ936H96"
    blockingProcesses=( thunderbird )
    ;;

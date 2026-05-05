libreofficelanguagepack_intl)
    name="LibreOffice Language Pack"
    type="dmg"
    packageID="org.libreoffice.script.langpack"
    userLanguage=$(runAsUser defaults read .GlobalPreferences AppleLanguages | head -2 | tail -1 | tr -dc "[:alnum:]\-")
    if [[ "$userLanguage" == "en-US" ]]; then
        cleanupAndExit 0 "No installation of a language pack is necessary for the US-English language."
    fi
    appNewVersion="$(curl -s https://download.documentfoundation.org/libreoffice/stable/ | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | tail -1)"
    releaseURL="https://download.documentfoundation.org/libreoffice/stable/"$appNewVersion"/mac/aarch64/"
    until curl -fs $releaseURL | grep -q "_$userLanguage.dmg"; do
        if [ ${#userLanguage} -eq 2 ]; then
            break
        fi
        printlog "No locale matching '$userLanguage', trying '${userLanguage:0:2}'"
        userLanguage=${userLanguage:0:2}
    done
    printlog "Using language '$userLanguage' for download."
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.documentfoundation.org/libreoffice/stable/"$appNewVersion"/mac/aarch64/LibreOffice_"$appNewVersion"_MacOS_aarch64_langpack_"$userLanguage".dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.documentfoundation.org/libreoffice/stable/"$appNewVersion"/mac/x86_64/LibreOffice_"$appNewVersion"_MacOS_x86-64_langpack_"$userLanguage".dmg"
    fi
    installerTool="LibreOffice Language Pack.app"
    CLIInstaller="LibreOffice Language Pack.app/Contents/LibreOffice Language Pack"
    expectedTeamID="7P5S3ZLCN7"
    ;;

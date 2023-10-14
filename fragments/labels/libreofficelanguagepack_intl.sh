libreofficelanguagepack_intl)
    name="LibreOffice Language Pack"
    # appName="LibreOffice.app"
    #
    # Reads the primary language of the system and installs the appropriate language pack for the latest LibreOffice STABLE version
    # There is no language pack for the US English language and no installation is required other than the LibreOffice software itself.
    # Use in combination and after installing Libre Office (STABLE Version)
    # This label requires user interaction to complete the installation
    #
    type="dmg"
    packageID="org.libreoffice.script.langpack"
    userLanguage=$(runAsUser defaults read .GlobalPreferences AppleLanguages | head -2 | tail -1 | tr -dc "[:alnum:]\-")
    if [[ "$userLanguage" == "en-US" ]]; then
        cleanupAndExit 0 "No installation of a language pack is necessary for the US-English language."
    fi
    appNewVersion="$(curl -Ls https://www.libreoffice.org/download/download-libreoffice/ | grep dl_version_number | head -n 1 | cut -d'>' -f3 | cut -d'<' -f1)"
    releaseURL="https://download.documentfoundation.org/libreoffice/stable/"$appNewVersion"/mac/aarch64/"
    until curl -fs $releaseURL | grep -q "_$userLanguage.dmg"; do
        if [ ${#userLanguage} -eq 2 ]; then
            break
        fi
        printlog "No locale matching '$userLanguage', trying '${userLanguage:0:2}'"
        userLanguage=${userLanguage:0:2}
    done
    printlog "Using language '$userLanguage' for download."
    # downloadURL="https://downloadarchive.documentfoundation.org/libreoffice/old/latest/mac/aarch64/"
    # if ! curl -sfL --output /dev/null -r 0-0 $downloadURL; then
    #     printlog "Download not found for '$userLanguage', exiting."
    #     exit
    # fi
    # appNewVersion=$(curl -sf $releaseURL | grep -m 1 "_langpack_$userLanguage.dmg" | sed "s|.*LibreOffice_\(.*\)_MacOS.*|\\1|")
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.documentfoundation.org/libreoffice/stable/"$appNewVersion"/mac/aarch64/LibreOffice_"$appNewVersion"_MacOS_aarch64_langpack_"$userLanguage".dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.documentfoundation.org/libreoffice/stable/"$appNewVersion"/mac/x86_64/LibreOffice_"$appNewVersion"_MacOS_x86-64_langpack_"$userLanguage".dmg"
    fi
    installerTool="LibreOffice Language Pack.app"
    CLIInstaller="LibreOffice Language Pack.app/Contents/LibreOffice Language Pack"
    expectedTeamID="7P5S3ZLCN7"
    # blockingProcesses=( soffice )
    ;;

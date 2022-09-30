adobereaderdc-update)
    name="Adobe Acrobat Reader DC"
    type="pkgInDmg"
    if [[ -d "/Applications/Adobe Acrobat Reader DC.app" ]]; then
        printlog "Found /Applications/Adobe Acrobat Reader DC.app"
        mkdir -p "/Library/Application Support/Adobe/Acrobat/11.0"
        defaults write "/Library/Application Support/Adobe/Acrobat/11.0/com.adobe.Acrobat.InstallerOverrides.plist" ReaderAppPath "/Applications/Adobe Acrobat Reader DC.app"
        if ! defaults read "/Applications/Adobe Acrobat Reader DC.app/Contents/Resources/AcroLocale.plist" ; then
            printlog "Missing locale data, this will cause the updater to fail. Deleting Adobe Acrobat Reader DC.app and installing fresh." WARN
            rm -Rf "/Applications/Adobe Acrobat Reader DC.app"
            if [[ $1 == "/" ]]; then
                printlog "Running through Jamf: $0." INFO
                $0 $1 $2 $3 adobereaderdc-install ${5} ${6} ${7} ${8} ${9} ${10} ${11}
            else
                printlog "Installomator running locally: $0." INFO
                $0 adobereaderdc-install ${2} ${3} ${4} ${5} ${6} ${7} ${8} ${9} ${10} ${11}
            fi
        fi
    fi
    adobecurrent=$(curl -sL https://armmf.adobe.com/arm-manifests/mac/AcrobatDC/reader/current_version.txt | tr -d '.')
    if [[ "${adobecurrent}" != <-> ]]; then
        printlog "Got an invalid response for the Adobe Reader Current Version: ${adobecurrent}" ERROR
        printlog "################## End $APPLICATION \n\n" INFO
        exit 50
    fi
    downloadURL=$(echo https://ardownload2.adobe.com/pub/adobe/reader/mac/AcrobatDC/"$adobecurrent"/AcroRdrDCUpd"$adobecurrent"_MUI.dmg)
    reader_preinstall() {
        if pgrep -a "AdobeReader" >/dev/null 2>&1; then
        printlog "AdobeReader is still running, forcefully killing." WARN
        killall AdobeReader
        fi
    }
    preinstall="reader_preinstall"
    updateTool="/usr/local/bin/RemoteUpdateManager"
    updateToolArguments=( --productVersions=RDR )
    appNewVersion=$(curl -s https://armmf.adobe.com/arm-manifests/mac/AcrobatDC/reader/current_version.txt)
    updateToolLog="/Users/$currentUser/Library/Logs/RemoteUpdateManager.log"
    updateToolLogDateFormat="%m/%d/%y %H:%M:%S"
    expectedTeamID="JQ525L2MZD"
    blockingProcesses=( "AdobeReader" )
    Company=Adobe
    PatchName=AcrobatReader
    PatchSkip="YES"
    ;;

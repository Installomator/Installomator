adobereaderdc|\
adobereaderdc-install|\
adobereaderdc-update)
    name="Adobe Acrobat Reader"
    type="pkgInDmg"
    if [[ -d "/Applications/Adobe Acrobat Reader DC.app" ]]; then
      printlog "Found /Applications/Adobe Acrobat Reader DC.app - Setting readerPath" INFO
      readerPath="/Applications/Adobe Acrobat Reader DC.app"
      name="Adobe Acrobat Reader DC"
    elif [[ -d "/Applications/Adobe Acrobat Reader.app" ]]; then
      printlog "Found /Applications/Adobe Acrobat Reader.app - Setting readerPath" INFO
      readerPath="/Applications/Adobe Acrobat Reader.app"
    fi
    if ! [[ `defaults read "$readerPath/Contents/Resources/AcroLocale.plist"` ]]; then
      printlog "Missing locale data, this will cause the updater to fail.  Deleting Adobe Acrobat Reader DC.app and installing fresh." INFO
      rm -Rf "$readerPath"
      unset $readerPath
    fi
    if [[ -n $readerPath ]]; then
      mkdir -p "/Library/Application Support/Adobe/Acrobat/11.0"
      defaults write "/Library/Application Support/Adobe/Acrobat/11.0/com.adobe.Acrobat.InstallerOverrides.plist" ReaderAppPath "$readerPath"
      defaults write "/Library/Application Support/Adobe/Acrobat/11.0/com.adobe.Acrobat.InstallerOverrides.plist" BreakIfAppPathInvalid -bool false
      printlog "Adobe Reader Installed, running updater." INFO
      adobecurrent=$(curl -sL https://armmf.adobe.com/arm-manifests/mac/AcrobatDC/reader/current_version.txt)
      adobecurrentmod="${adobecurrent//.}"
      if [[ "${adobecurrentmod}" != <-> ]]; then
        printlog "Got an invalid response for the Adobe Reader Current Version: ${adobecurrent}" ERROR
        printlog "################## End $APPLICATION \n\n" INFO
        exit 50
      fi
      if pgrep -q "Acrobat Updater"; then
        printlog "Adobe Acrobat Updater Running, killing it to avoid any conflicts" INFO
        killall "Acrobat Updater"
      fi
      downloadURL=$(echo https://ardownload2.adobe.com/pub/adobe/reader/mac/AcrobatDC/"$adobecurrentmod"/AcroRdrDCUpd"$adobecurrentmod"_MUI.dmg)
      appNewVersion="${adobecurrent}"
    else
      printlog "Changing IFS for Adobe Reader" INFO
      SAVEIFS=$IFS
      IFS=$'\n'
      versions=( $( curl -s https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/index.html | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+"| head -n 30) )
      local version
      for version in $versions; do
        version="${version//.}"
        printlog "trying version: $version" INFO
        local httpstatus=$(curl -X HEAD -s "https://ardownload2.adobe.com/pub/adobe/reader/mac/AcrobatDC/${version}/AcroRdrDC_${version}_MUI.dmg" --write-out "%{http_code}")
        printlog "HTTP status for Adobe Reader full installer URL https://ardownload2.adobe.com/pub/adobe/reader/mac/AcrobatDC/${version}/AcroRdrDC_${version}_MUI.dmg is $httpstatus" DEBUG
        if [[ "${httpstatus}" == "200" ]]; then
          downloadURL="https://ardownload2.adobe.com/pub/adobe/reader/mac/AcrobatDC/${version}/AcroRdrDC_${version}_MUI.dmg"
          unset httpstatus
          break
        fi
      done
      unset version
      IFS=$SAVEIFS
    fi
    updateTool="/usr/local/bin/RemoteUpdateManager"
    updateToolArguments=( --productVersions=RDR )
    updateToolLog="/Users/$currentUser/Library/Logs/RemoteUpdateManager.log"
    updateToolLogDateFormat="%m/%d/%y %H:%M:%S"
    expectedTeamID="JQ525L2MZD"
    blockingProcesses=( "Acrobat Pro DC" "AdobeAcrobat" "AdobeReader" "Distiller" )
    Company="Adobe"
    ;;

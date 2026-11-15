adobereaderdc|\
adobereaderdc-install|\
adobereaderdc-update)
    name="Adobe Acrobat Reader"
    type="pkgInDmg"
    if [[ ! -d "/Applications/Adobe Acrobat Reader.app" && -d "/Applications/Adobe Acrobat Reader DC.app" ]]; then
        appName="Adobe Acrobat Reader DC.app"
    fi
    adobeReaderVersion=$(curl -fsL "https://armmf.adobe.com/arm-manifests/mac/AcrobatDC/reader/current_version.txt" | tr -d '[:space:]')
    adobeReaderVersionDotless="${adobeReaderVersion//./}"
    if [[ ! "$adobeReaderVersion" =~ '^[0-9]+\.[0-9]+\.[0-9]+$' ]]; then
        cleanupAndExit 50 "Invalid Adobe Acrobat Reader version from ARM manifest: '${adobeReaderVersion}'" ERROR
    fi
    downloadURL="https://ardownload2.adobe.com/pub/adobe/reader/mac/AcrobatDC/${adobeReaderVersionDotless}/AcroRdrDC_${adobeReaderVersionDotless}_MUI.dmg"
    appNewVersion="$adobeReaderVersion"
    expectedTeamID="JQ525L2MZD"
    blockingProcesses=( "Acrobat Pro DC" "AdobeAcrobat" "AdobeReader" "Distiller" )
    updateTool="/usr/local/bin/RemoteUpdateManager"
    updateToolArguments=( --productVersions=RDR )
    updateToolLog="/Users/$currentUser/Library/Logs/RemoteUpdateManager.log"
    updateToolLogDateFormat="%m/%d/%y %H:%M:%S"
    ;;

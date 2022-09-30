adobereaderdc-install)
    name="Adobe Acrobat Reader DC"
    type="pkgInDmg"
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
    appNewVersion=$i
    expectedTeamID="JQ525L2MZD"
    blockingProcesses=( "AdobeReader" )
    Company="Adobe"
    PatchName="AcrobatReader"
    ;;

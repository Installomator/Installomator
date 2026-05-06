decimatorucp)
    name="Decimator UCP"
    type="dmg"
    blockingProcesses=( "DCP" )
    if [[ $(arch) != "i386" ]]; then
        printlog "Architecture: arm64"
        downloadURL=$(curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/536.28.10 (KHTML, like Gecko) Version/6.0.3 Safari/536.28.10" -fs "https://decimator.com/DOWNLOADS/DOWNLOADS.html" \
        | grep -E -o "https:\/\/decimator\.com\/specs\/UCP.*ARM\.dmg" \
        | head -1 \
        | sed 's/ /%20/g')
        appNewVersion=$( echo "${downloadURL}" | grep -oE '[0-9]+.[0-9]+.[0-9]+' | sed 's/^..//')
        appName="UCP ${appNewVersion} ARM.app"
    else
        printlog "Architecture: i386"
        downloadURL=$(curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/536.28.10 (KHTML, like Gecko) Version/6.0.3 Safari/536.28.10" -fs "https://decimator.com/DOWNLOADS/DOWNLOADS.html" \
        | grep -E -o "https:\/\/decimator\.com\/specs\/UCP.*Intel\.dmg" \
        | head -1 \
        | sed 's/ /%20/g')
        appNewVersion=$( echo "${downloadURL}" | grep -oE '[0-9]+.[0-9]+.[0-9]+' | sed 's/^..//')
        appName="UCP ${appNewVersion} intel.app"
    fi
    expectedTeamID="XQ28RQTB52"
    ;;

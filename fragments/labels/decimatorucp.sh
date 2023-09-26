decimatorucp)
    name="Decimator UCP"
    type="dmg"
    blockingProcesses=( "DCP" )
    downloadURL=$(curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/536.28.10 (KHTML, like Gecko) Version/6.0.3 Safari/536.28.10" -fs "http://decimator.com/DOWNLOADS/DOWNLOADS.html" | xmllint --html -xpath "string((//a[contains(@href, '.dmg')])[1]/@href)" - 2> /dev/null | sed 's/ /%20/g')
    appNewVersion=$( echo "${downloadURL}" | grep -oE '%([0-9.]+)' | sed 's/.$//' | sed 's/%20//g') 
    appName="UCP ${appNewVersion}.app"
    expectedTeamID="XQ28RQTB52"
    ;;
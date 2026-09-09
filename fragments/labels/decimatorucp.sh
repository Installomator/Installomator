decimatorucp)
    name="Decimator UCP"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        decimatorArchitecture="ARM"
    else
        decimatorArchitecture="Intel"
    fi
    downloadURL=$(curl -fsL "https://decimator.com/DOWNLOADS/DOWNLOADS.html" | awk -v arch="$decimatorArchitecture" -F'"' '$2 ~ "https://decimator.com/specs/UCP [0-9]+\\.[0-9]+\\.[0-9]+ " arch "\\.dmg" { gsub(/ /, "%20", $2); print $2; exit }')
    appNewVersion=$(sed -E "s#.*UCP%20([0-9]+\.[0-9]+\.[0-9]+)%20${decimatorArchitecture}\.dmg#\1#" <<< "$downloadURL")
    appName="UCP ${appNewVersion} ${decimatorArchitecture}.app"
    appCustomVersion(){ [[ -d "/Applications/$appName" ]] && sed -E "s/^UCP ([0-9]+\.[0-9]+\.[0-9]+) ${decimatorArchitecture}\.app$/\1/" <<< "$appName"; }
    blockingProcesses=( "ucp" )
    expectedTeamID="XQ28RQTB52"
    ;;

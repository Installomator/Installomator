davinciresolvestudio | \
blackmagicdavinciresolvestudio)
    name="DaVinci Resolve Studio"
    appName="DaVinci Resolve/DaVinci Resolve.app"
    type="pkgInDmgInZip"
    downloadID=$(curl -fs https://www.blackmagicdesign.com/api/support/us/downloads.json | jq -r '[.downloads.[]|select(.name | startswith ("DaVinci Resolve Studio"))][0].urls|."Mac OS X".[].downloadId')
    downloadURL=$(curl --compressed --location --header "Content-Type: application/json;charset=UTF-8" --header "User-Agent: Mozilla/5.0" --data '{"country": "us", "platform": "Mac OS X", "product": "DaVinci Resolve Studio"}' \
        "https://www.blackmagicdesign.com/api/register/us/download/${downloadID}")
    appNewVersionRAW=$(echo ${downloadURL} | grep -oE '_([0-9.]+)' | cut -d'_' -f2)
    if [[ $(echo ${appNewVersionRAW} | awk -F'.' '{ print NF }') -gt 2 ]]; then
        appNewVersion="${appNewVersionRAW}"
    else
        appNewVersion="${appNewVersionRAW}.0"
    fi
    blockingProcesses=( Resolve "DaVinci Control Panels Setup" "DaVinci Remote Monitor" "Fairlight Studio Utility" )
    expectedTeamID="9ZGFBWLSYP"
    ;;

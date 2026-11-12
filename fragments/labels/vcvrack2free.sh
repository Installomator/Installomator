vcvrack2free)
    name="VCV Rack 2 Free"
    type="pkg"
    downloadFile=$(curl -fsL "https://vcvrack.com/downloads/" | grep -Eo 'RackFree-[0-9]+(\.[0-9]+)+-mac-x64\+arm64\.pkg' | head -n 1)
    appNewVersion=$(echo "$downloadFile" | sed -E 's/^RackFree-([0-9]+(\.[0-9]+)+)-mac-x64\+arm64\.pkg$/\1/')
    downloadURL="https://vcvrack.com/downloads/${downloadFile}"
    expectedTeamID="V8SW9J626X"
    ;;

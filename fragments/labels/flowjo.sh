flowjo)
    name="FlowJo 11"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="$(curl -fs "https://www.flowjo.com/flowjo/download" | grep -i -o -E "https.*\.dmg" | grep -m 1 'arm64')"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="$(curl -fs "https://www.flowjo.com/flowjo/download" | grep -i -o -E "https.*\.dmg" | grep -m 1 'x64')"
    fi
    appNewVersion=$(echo "${downloadURL}" | cut -d "-" -f2 )
    expectedTeamID="C79HU5AD9V"
    ;;

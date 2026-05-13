tidal)
    name="TIDAL"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
        downloadURL=https://download.tidal.com/desktop/TIDAL.x64.dmg
    elif [[ $(arch) == arm64 ]]; then
        downloadURL=https://download.tidal.com/desktop/TIDAL.arm64.dmg
    fi
    appNewVersion=$(curl -fs https://support.datajar.co.uk/hc/en-us/articles/360010333638-Jamf-Auto-Update-Application-Catalog | grep -ozpEi ">TIDAL<\/td>\n<td>(.*)<" | grep -oE "((?:[0-9]+\.?)+)" | head -1)
    expectedTeamID="GK2243L7KB"
    ;;

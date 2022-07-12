blender)
    name="blender"
    type="dmg"
	if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(redirect=$(curl -sfL https://www.blender.org/download/ | sed 's/.*href="//' | sed 's/".*//' | grep arm64.dmg) && curl -sfL "$redirect" | sed 's/.*href="//' | sed 's/".*//' | grep -m1 .dmg)
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(redirect=$(curl -sfL https://www.blender.org/download/ | sed 's/.*href="//' | sed 's/".*//' | grep x64.dmg) && curl -sfL "$redirect" | sed 's/.*href="//' | sed 's/".*//' | grep -m1 .dmg)
    fi    
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)-.*/\1/g' )
    expectedTeamID="68UA947AUU"
    ;;
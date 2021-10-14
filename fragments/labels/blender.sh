blender)
    name="blender"
    type="dmg"
    downloadURL=$(redirect=$(curl -sfL https://www.blender.org/download/ | sed 's/.*href="//' | sed 's/".*//' | grep .dmg) && curl -sfL "$redirect" | sed 's/.*href="//' | sed 's/".*//' | grep -m1 .dmg)
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)-.*/\1/g' )
    expectedTeamID="68UA947AUU"
    ;;

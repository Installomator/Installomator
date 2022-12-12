blender)
    name="blender"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -sfL "https://www.blender.org/download/" | xmllint --html --format - 2>/dev/null | grep -o "https://.*blender.*arm64.*.dmg" | sed '2p;d' | sed 's/www.blender.org\/download/download.blender.org/g')
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -sfL "https://www.blender.org/download/" | xmllint --html --format - 2>/dev/null | grep -o "https://.*blender.*x64.*.dmg" | sed '2p;d' | sed 's/www.blender.org\/download/download.blender.org/g')
    fi
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)-.*/\1/g' )
    expectedTeamID="68UA947AUU"
    ;;

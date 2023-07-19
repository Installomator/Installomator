dropbox)
    name="Dropbox"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
       downloadURL="https://www.dropbox.com/download?plat=mac&type=full&arch=arm64"
       appNewVersion=$(curl -fsIL "$downloadURL" | grep -i "^location" | sed -E 's/.*%20([0-9.]*).\arm64\.dmg/\1/g')
    elif [[ $(arch) == "x86_64" ]]; then
       downloadURL="https://www.dropbox.com/download?plat=mac&type=full&arch=intel"
       appNewVersion=$(curl -fsIL "$downloadURL" | grep -i "^location" | sed -E 's/.*%20([0-9.]*)\.dmg/\1/g')
    fi
    expectedTeamID="G7HH3F8CAK"
    ;;

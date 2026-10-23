archimate)
    name="Archi"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
      downloadURL=$(curl -s https://www.archimatetool.com/download/ | grep -oE 'href="[^"]+\.dmg"' | cut -d'"' -f2 | grep -E '[sS]ilicon')
    elif [[ $(arch) == "i386" ]]; then
      downloadURL=$(curl -s https://www.archimatetool.com/download/ | grep -oE 'href="[^"]+\.dmg"' | cut -d'"' -f2 | grep -Ev '[sS]ilicon')
    fi
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*\/([0-9]+\.[0-9]+\.[0-9]+)\/.*/\1/')
    expectedTeamID="375WT5T296"
    ;;

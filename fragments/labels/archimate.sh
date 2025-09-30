archimate)
    name="Archi"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
      downloadURL=$(curl -s https://www.archimatetool.com/download/ | grep dmg | sed -n 's/.*href="\([^"]*\)".*/\1/p' | awk 'NR==2')
    elif [[ $(arch) == "i386" ]]; then
      downloadURL=$(curl -s https://www.archimatetool.com/download/ | grep dmg | sed -n 's/.*href="\([^"]*\)".*/\1/p' | awk 'NR==1')
    fi
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*\/([0-9]+\.[0-9]+\.[0-9]+)\/.*/\1/')
    expectedTeamID="375WT5T296"
    ;;

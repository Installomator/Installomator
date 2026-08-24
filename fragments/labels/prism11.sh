prism11)
    name="Prism 11"
    type="dmg"
    downloadURL="https://cdn.graphpad.com/downloads/prism/11/InstallPrism11.dmg"
    appNewVersion=$(curl -fs "https://www.graphpad.com/updates" | grep -Eio 'The latest Prism version is.*' | cut -d "(" -f 1 | awk -F '<!-- --> <!-- -->' '{print $2}' | cut -d "<" -f 1)
    expectedTeamID="YQ2D36NS9M"
    ;;

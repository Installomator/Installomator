synergyeditor|synergyeditorbasketball)
    name="Synergy Editor"
    type="dmg"
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL=$( echo https://www.synergysportstech.com/apps/editor/basketball/macos/$(curl -s https://www.synergysportstech.com/apps/editor/basketball/macos/ | grep arm64.dmg | grep -o 'href="[^"]*' | head -1 | awk -F '="' '{print $NF}' ))
    else
        downloadURL=$( echo https://www.synergysportstech.com/apps/editor/basketball/macos/$(curl -s https://www.synergysportstech.com/apps/editor/basketball/macos/ | grep x64.dmg | grep -o 'href="[^"]*' | head -1 | awk -F '="' '{print $NF}' ))
    fi
    appNewVersion=$(curl -fs https://www.synergysportstech.com/apps/editor/basketball/macos/default.html | grep Version: | grep -o -e "[0-9.]*")
    versionKey="CFBundleShortVersionString"
    expectedTeamID="BATB6XS52B"
    ;;

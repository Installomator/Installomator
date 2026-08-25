synergyeditor|synergyeditorbasketball)
    name="Synergy Editor"
    type="dmg"
    baseURL="https://www.synergysportstech.com/apps/editor/basketball/macos"
    if [[ "$(arch)" == "arm64" ]]; then
        dmgPath=$(curl -s "$baseURL/" | grep -o 'href="[^"]*arm64\.dmg[^"]*"' | head -1 | sed 's/href="//;s/"//')
    else
        dmgPath=$(curl -s "$baseURL/" | grep -o 'href="[^"]*x64\.dmg[^"]*"' | head -1 | sed 's/href="//;s/"//')
    fi
    downloadURL="${baseURL}/${dmgPath}"
    appNewVersion=$(curl -fs https://www.synergysportstech.com/apps/editor/basketball/macos/default.html | grep Version: | grep -o -e "[0-9.]*")
    expectedTeamID="BATB6XS52B"
    ;;

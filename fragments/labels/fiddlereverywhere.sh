fiddlereverywhere)    
    name="Fiddler Everywhere"
    type="dmg"
    blockingProcesses=( "Fiddler Everywhere" )
    downloadURL=$(curl -fsL -o /dev/null -w "%{url_effective}" \
        "https://www.telerik.com/download/fiddler/fiddler-everywhere-osx-silicon")
    if [[ "$downloadURL" != *"downloads.getfiddler.com"* ]]; then
        appNewVersion=$(curl -fsL \
            "https://www.telerik.com/support/whats-new/fiddler-everywhere/release-history" \
            | grep -oE 'fiddler-everywhere-v[0-9]+\.[0-9]+(\.[0-9]+)?' \
            | head -1 \
            | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?')
        downloadURL="https://downloads.getfiddler.com/mac-arm64/Fiddler%20Everywhere%20${appNewVersion}.dmg"
    fi
    appNewVersion=$(echo "$downloadURL" \
        | sed -E 's|.*/[^/]*%20([0-9]+\.[0-9]+(\.[0-9]+)?)\.dmg.*|\1|')
    expectedTeamID="CHSQ3M3P37"
    ;;
mixxx)
    name="Mixxx"
    type="dmg"
    appNewVersion="$(curl -fsL "https://downloads.mixxx.org/releases/" | grep -Eo 'href="[0-9]+(\.[0-9]+)+/"' | sed -E 's/href="([^"]+)\/"/\1/' | sort -V | tail -n 1)"
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL="https://downloads.mixxx.org/releases/$appNewVersion/mixxx-$appNewVersion-macosarm.dmg"
    else
        downloadURL="https://downloads.mixxx.org/releases/$appNewVersion/mixxx-$appNewVersion-macosintel.dmg"
    fi
    expectedTeamID="JBLRSP95FC"
    ;;

filmlab)
    name="FilmLab"
    type="dmg"
    appNewVersion="$(curl -fsL "https://downloads.filmlabapp.com/desktop/latest-mac.yml" | grep -E 'version' | awk '{print $2}')"
    downloadURL="https://downloads.filmlabapp.com/desktop/FilmLab-$appNewVersion-universal.dmg"
    expectedTeamID="UAGC35XKV5"
    ;;

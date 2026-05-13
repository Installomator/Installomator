xmplify)
    name="Xmplify"
    type="dmg"
    downloadURL="https://xmplifyapp.com/releases/Xmplify.dmg"
    appNewVersion="$(curl -sL "https://xmplifyapp.com/release-notes/current.html" | xmllint --html --xpath 'string(//h3[contains(., "Release Notes")][1])' - 2>/dev/null | grep -oE "[0-9].*[0-9]")"
    expectedTeamID="KK854LLJJ7"
    ;;

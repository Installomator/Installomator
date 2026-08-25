ricohtheta)
    name="RICOH THETA"
    type="dmg"
    versionKey="CFBundleShortVersionString"
    downloadURL="https://theta360.com/intl/support/download/pcapp/macosx"
    appNewVersion=$(curl -fsL "https://support.ricoh360.com/system-information?news-tags=support" | xmllint --html --xpath "string((//a[contains(normalize-space(), 'RICOH THETA PC App Version')])[1])" - 2>/dev/null | grep -Eom1 '[vV]?[0-9]+(\.[0-9]+)+' | sed 's/^[vV]//')
    expectedTeamID="5KACUT3YX8"
    ;;

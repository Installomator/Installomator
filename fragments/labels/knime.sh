knime)
    latestMinor=$(curl -fsL "https://docs.knime.com/latest/analytics_platform_release_notes/index.html" | grep -oE 'Version [0-9]+\.[0-9]+' | head -n 1 | awk '{print $2}')
    appNewVersion=$(curl -fsL "https://docs.knime.com/ap/latest/changelogs/${latestMinor}/" | grep -oE 'KNIME Analytics Platform [0-9]+\.[0-9]+\.[0-9]+' | head -n 1 | awk '{print $4}')
    name="KNIME ${appNewVersion}"
    type="dmg"
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL="https://download.knime.com/analytics-platform/macosx/knime_${appNewVersion}.app.macosx.cocoa.aarch64.dmg"
    elif [[ "$(arch)" == "i386" ]]; then
        downloadURL="https://download.knime.com/analytics-platform/macosx/knime_${appNewVersion}.app.macosx.cocoa.x86_64.dmg"
     fi
    expectedTeamID="V7WZJX2HS9"
    ;;

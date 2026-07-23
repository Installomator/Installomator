googlechrome)
    name="Google Chrome"
    type="dmg"
    downloadURL="https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg"
    appNewVersion=$(curl -s "https://versionhistory.googleapis.com/v1/chrome/platforms/mac/channels/stable/versions/all/releases?filter=fraction%3E0.01,endtime=none&order_by=version%20desc" | grep "name" | grep -m1 -oE 'versions/[^/]+/releases' | cut -d'/' -f2)
    expectedTeamID="EQHXZ8M8AV"
    printlog "WARNING for ERROR: Label googlechrome should not be used. Instead use googlechromepkg as per recommendations from Google. It's not fully certain that the app actually gets updated here. googlechromepkg will have built in updates and make sure the client is updated in the future." REQ
    ;;

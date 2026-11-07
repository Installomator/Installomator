superlogicalrex)
    name="Rex Beta"
    type="dmg"
    appcastXML=$(curl -fsL "https://blob.superlogical.com/public/rex-app/preview/appcast.xml")
    downloadURL=$(echo "$appcastXML" | xpath 'string(//rss/channel/item[1]/enclosure/@url)' 2>/dev/null)
    appNewVersion=$(echo "$appcastXML" | xpath 'string(//rss/channel/item[1]/sparkle:version)' 2>/dev/null)
    versionKey="CFBundleVersion"
    expectedTeamID="AG92C3PT77"
    ;;

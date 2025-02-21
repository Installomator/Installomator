finaldraft13)
    #credit to @adamcodega on Slack for helping to fix the curl
    name="Final Draft 13"
    type="appInDmgInZip"
    downloadURL="https://www.finaldraft.com$(curl -fs "https://www.finaldraft.com/support/install-final-draft/install-final-draft-13-macintosh/" | xmllint --html --format - 2>/dev/null | grep -o "/downloads/finaldraft.*.zip" | head -n 1)"
    appNewVersion=$(echo $downloadURL | cut -d 't' -f5 | cut -f1 -d "M")
    versionKey="CFBundleShortVersionString"
    expectedTeamID="7XUZ8R5736"
    ;;

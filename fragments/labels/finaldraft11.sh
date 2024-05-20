finaldraft11)
    name="Final Draft 11"
    type="pkgInZip"
    downloadURL="https://www.finaldraft.com"
    downloadURL+=$(curl -fs "https://www.finaldraft.com/support/install-final-draft/install-final-draft-11-macintosh/" | xmllint --html --format - 2>/dev/null | grep -o "/downloads/finaldraft.*.zip")
    appNewVersion=$(echo $downloadURL | cut -d 't' -f5 | cut -f1 -d "M")
    expectedTeamID="7XUZ8R5736"
    ;;

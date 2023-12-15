mactracker)
    name="Mactracker"
    type="zip"
    downloadURL=$(curl -fs "https://mactracker.ca/releasenotes-mac.html" | grep "Mactracker_" | sed "s|.*href=\"\(.*\)\">Download for macOS.*|\\1|")
    appNewVersion=$(curl -fs "https://mactracker.ca/releasenotes-mac.html" | grep -m 1 'Version ' | sed "s|.*Version \(.*\)</strong.*|\\1|")
    expectedTeamID="63TP32R3AB"
    ;;

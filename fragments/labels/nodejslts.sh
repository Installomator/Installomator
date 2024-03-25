nodejslts)
    name="nodejs"
    type="pkg"
    appNewVersion=$(curl -fsL https://nodejs.org/en | xmllint --html --xpath '//a[contains(text(),"LTS")]/@href' - 2>/dev/null | grep -oE 'v[0-9]+(\.[0-9]+)*' | head -1)
    downloadURL="https://nodejs.org/dist/$appNewVersion/node-$appNewVersion.pkg"
    appCustomVersion(){/usr/local/bin/node -v}
    expectedTeamID="HX7739G8FX"
    ;;

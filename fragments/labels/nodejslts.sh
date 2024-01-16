nodejslts)
    name="nodejs"
    type="pkg"
    downloadURL=$(curl -fsL 'https://nodejs.org/en/download' | grep -oE 'https://[^"]*node-v[0-9.]+.pkg' | head -1)
    appNewVersion=$(sed -E 's/.*(v[0-9.]+)\.pkg/\1/g' <<< $downloadURL)
    appCustomVersion(){/usr/local/bin/node -v}
    expectedTeamID="HX7739G8FX"
    ;;

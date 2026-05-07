nodejslts)
    name="nodejs"
    type="pkg"
    appNewVersion=$(curl -fs https://nodejs.org/dist/index.json | jq -r '[.[] | select(.lts)][0].version')
    downloadURL="https://nodejs.org/dist/$appNewVersion/node-$appNewVersion.pkg"
    appCustomVersion(){/usr/local/bin/node -v}
    expectedTeamID="HX7739G8FX"
    ;;

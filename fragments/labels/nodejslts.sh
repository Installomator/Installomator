nodejslts)
    name="nodejs"
    type="pkg"
    appNewVersion=$(getJSONValue "$(curl -fsL https://nodejs.org/dist/index.json)" "filter(x => x.lts)[0].version")
    downloadURL="https://nodejs.org/dist/$appNewVersion/node-$appNewVersion.pkg"
    appCustomVersion(){/usr/local/bin/node -v}
    expectedTeamID="HX7739G8FX"
    ;;

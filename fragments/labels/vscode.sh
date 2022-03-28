vscode)
    name="Visual Studio Code"
    type="zip"
    downloadURL="https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal"
    appNewVersion=$(curl -fsL "https://code.visualstudio.com/updates" | grep -Eo "https?://\S+?\"" | sed 's/&.*//' | grep -i "darwin-universal" | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/')
    expectedTeamID="UBF8T346G9"
    ;;

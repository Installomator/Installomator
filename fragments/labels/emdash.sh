emdash)
    name="Emdash"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://github.com/generalaction/emdash/releases/latest/download/emdash-arm64.dmg"
    else
        downloadURL="https://github.com/generalaction/emdash/releases/latest/download/emdash-x64.dmg"
    fi
    appNewVersion=$(versionFromGit generalaction emdash)
    expectedTeamID="2AZ6648627"
    ;;

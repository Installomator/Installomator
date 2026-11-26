codexbar)
    name="CodexBar"
    type="zip"
    downloadURL=$(curl -sfL "https://api.github.com/repos/steipete/CodexBar/releases/latest" | awk -F '"' '/browser_download_url/ && /CodexBar-macos-universal-[0-9.]+\.zip"/ { print $4; exit }')
    appNewVersion=$(versionFromGit steipete CodexBar)
    expectedTeamID="Y5PE65HELJ"
    ;;

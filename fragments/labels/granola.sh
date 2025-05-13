granola)
    name="Granola"
    type="dmg"
    appNewVersion=$(curl -fs "https://formulae.brew.sh/api/cask/granola.json" | grep -o '"version":.*"' | head -1 | cut -d '"' -f 4)
    downloadURL="https://dr2v7l5emb758.cloudfront.net/${appNewVersion}/Granola-${appNewVersion}-mac-universal.dmg"
    expectedTeamID="QZ7DHHLN25"
    appName="Granola.app"
    blockingProcesses=( "Granola" )
    ;;

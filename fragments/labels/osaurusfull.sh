osaurusfull)
    name="Osaurus"
    type="dmg"
    if [[ $(arch) != "arm64" ]]; then
        printlog "Osaurus Full is only compatible with Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 95 "Osaurus Full requires Apple Silicon" ERROR
    fi
    appNewVersion=$(versionFromGit osaurus-ai osaurus)
    downloadURL="https://huggingface.co/datasets/OsaurusAI/osaurus-releases/resolve/main/${appNewVersion}/Osaurus-${appNewVersion}-full.dmg"
    appCustomVersion() { [[ -f "/Applications/Osaurus.app/Contents/Resources/BundledModels/manifest.json" ]] && defaults read "/Applications/Osaurus.app/Contents/Info" CFBundleShortVersionString || echo "0"; }
    expectedTeamID="4W8QF9VR2F"
    blockingProcesses=( "osaurus" )
    ;;

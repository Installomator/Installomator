brokenupdater)
    name="Google Chrome"
    type="dmg"
    if [[ $(arch) != "i386" ]]; then
        printlog "Architecture: arm64 (not i386)"
        downloadURL="https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg"
    else
        printlog "Architecture: i386"
        downloadURL="https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"
          fi
    expectedTeamID="EQHXZ8M8AV"
    updateTool="/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle/Contents/Resources/GoogleSoftwareUpdateAgent.app/Contents/MacOS/GoogleSoftwareUpdateAgent"
    updateToolArguments=( -runMode BLERG -userInitiated YES )
    updateToolRunAsCurrentUser=1
    ;;

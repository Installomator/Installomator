kimplusclientmodul)
    name="KIMplus Clientmodul"
    # appName="KIMplus Clientmodul.app"
    type="dmg"
    downloadName=$(curl -fs "https://cm.kimplus.de/download/current/updates.xml" | grep -i 'targetMediaFileId="mac"' | sed "s|.*fileName=\(.*\)newVersion.*|\\1|" | cut -d '"' -f 2)
    appNewVersion=$(curl -fs "https://cm.kimplus.de/download/current/updates.xml" | grep -i 'targetMediaFileId="mac"' | sed "s|.*newVersion=\(.*\)newMedia.*|\\1|" | cut -d '"' -f 2)
    downloadURL=https://cm.kimplus.de/download/current/$downloadName
    installerTool="KIMplus Clientmodul Installationsprogramm.app"
    CLIInstaller="KIMplus Clientmodul Installationsprogramm.app/Contents/MacOS/JavaApplicationStub"
    CLIArguments=(-q -overwrite)
    expectedTeamID="7QZS8E98SZ"
    blockingProcesses=( "JavaApplicationStub" )
    ;;

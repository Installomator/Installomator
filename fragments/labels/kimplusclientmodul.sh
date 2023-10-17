kimplusclientmodul)
    name="KIMplus Clientmodul"
    # appName="KIMplus Clientmodul.app"
    type="dmg"
    downloadName=$(curl -fs "https://cm.kimplus.de/download/current/" | grep "macos" | sed "s|.*href=\"\(.*\)\">kimplus-clientmodul.*|\\1|")
    appNewVersion=$(curl -fs "https://cm.kimplus.de/download/current/" | grep "macos" | sed "s|.*kimplus-clientmodul_\(.*\)_macos.dmg.*|\\1|" | sed s/_/./g)
    downloadURL=https://cm.kimplus.de/download/current/$downloadName
    installerTool="KIMplus Clientmodul Installationsprogramm.app"
    CLIInstaller="KIMplus Clientmodul Installationsprogramm.app/Contents/MacOS/JavaApplicationStub"
    CLIArguments=(-q -overwrite)
    expectedTeamID="7QZS8E98SZ"
    blockingProcesses=( "JavaApplicationStub" )
    ;;

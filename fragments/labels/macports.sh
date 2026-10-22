macports)
    name="MacPorts"
    type="pkg"
    case "$installedOSversion" in
        27.*) archiveName="GoldenGate.pkg" ;;
        26.*) archiveName="Tahoe.pkg" ;;
        15.*) archiveName="Sequoia.pkg" ;;
        14.*) archiveName="Sonoma.pkg" ;;
        13.*) archiveName="Ventura.pkg" ;;
        12.*) archiveName="Monterey.pkg" ;;
        11.*) archiveName="BigSur.pkg" ;;
        10.15.*) archiveName="Catalina.pkg" ;;
        *) cleanupAndExit 98 "MacPorts does not support macOS $installedOSversion." ERROR ;;
    esac
    downloadURL=$(downloadURLFromGit macports macports-base)
    appNewVersion=$(versionFromGit macports macports-base)
    appCustomVersion(){ if [ -x /opt/local/bin/port ]; then /opt/local/bin/port version | awk '{print $2}'; fi }
    updateTool="/opt/local/bin/port"
    updateToolArguments="selfupdate"
    expectedTeamID="QTA3A3B7F3"
    blockingProcesses=( NONE )
    ;;

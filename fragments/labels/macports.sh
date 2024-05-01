macports)
    name="MacPorts"
    type="pkg"
    #buildVersion=$(uname -r | cut -d '.' -f 1)
    case $(uname -r | cut -d '.' -f 1) in
        23)
            archiveName="Sonoma.pkg"
            ;;
        22)
            archiveName="Ventura.pkg"
            ;;
        21)
            archiveName="Monterey.pkg"
            ;;
        20)
            archiveName="BigSur.pkg"
            ;;
        19)
            archiveName="Catalina.pkg"
            ;;
        *)
            cleanupAndExit 98 "macOS 10.14 or earlier not supported by Installomator."
            ;;
    esac
    downloadURL=$(downloadURLFromGit macports macports-base)
    appNewVersion=$(versionFromGit macports macports-base)
    appCustomVersion(){ if [ -x /opt/local/bin/port ]; then /opt/local/bin/port version | awk '{print $2}'; else "0"; fi }
    updateTool="/opt/local/bin/port"
    updateToolArguments="selfupdate"
    expectedTeamID="QTA3A3B7F3"
    ;;

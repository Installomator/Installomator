macports)
    name="MacPorts"
    type="pkg"
    #buildVersion=$(uname -r | cut -d '.' -f 1)
    case $(uname -r | cut -d '.' -f 1) in
        25)
            archiveName="Tahoe.pkg"
            ;;
	    24)
	        archiveName="Sequoia.pkg"
	        ;;
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
            cleanupAndExit 98 "Mac Ports label does not support this version of darwin."
            ;;
    esac
    downloadURL=$(downloadURLFromGit macports macports-base)
    appNewVersion=$(versionFromGit macports macports-base)
    appCustomVersion(){ if [ -x /opt/local/bin/port ]; then /opt/local/bin/port version | awk '{print $2}'; fi }
    updateTool="/opt/local/bin/port"
    updateToolArguments="selfupdate"
    expectedTeamID="QTA3A3B7F3"
    ;;

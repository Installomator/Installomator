mysqlworkbenchce)
    name="MySQL Workbench"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://dev.mysql.com/get/Downloads/MySQLGUITools/$(curl -fsL "https://dev.mysql.com/downloads/workbench/?os=33" | grep -o "mysql-workbench-[0-9.]*-macos-arm64.dmg" | head -1)"
    else
        printlog "MySQL Workbench is only compatible with Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 95 "MySQL Workbench requires Apple Silicon" ERROR
    fi
    appNewVersion="$(curl -fsL 'https://workbench.mysql.com/current-release' | grep fullversion | cut -d\" -f4)"
    expectedTeamID="VB5E2TV963"
    ;;

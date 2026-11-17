mysqlworkbenchce)
    name="MySQL Workbench"
    type="dmg"
    appNewVersion="$(getJSONValue "$(curl -fsL 'https://workbench.mysql.com/current-release')" fullversion)"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-${appNewVersion}-macos-arm64.dmg"
    else
        printlog "MySQL Workbench is only compatible with Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 95 "MySQL Workbench requires Apple Silicon" ERROR
    fi
    expectedTeamID="VB5E2TV963"
    ;;

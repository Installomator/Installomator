mysqlworkbenchce)
    name="MySQLWorkbench"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://dev.mysql.com/get/Downloads/MySQLGUITools/$(curl -fsL "https://dev.mysql.com/downloads/workbench/?os=33" | grep -o "mysql-workbench-community-.*-macos-arm64.dmg" | head -1)"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://dev.mysql.com/get/Downloads/MySQLGUITools/$(curl -fsL "https://dev.mysql.com/downloads/workbench/?os=33" | grep -o "mysql-workbench-community-.*-macos-x86_64.dmg" | head -1)"
    fi
    appNewVersion="$(curl -fsL 'http://workbench.mysql.com/current-release' | grep fullversion | cut -d\" -f4).CE"
    expectedTeamID="VB5E2TV963"
    ;;

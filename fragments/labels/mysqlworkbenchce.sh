mysqlworkbenchce)
    name="MySQLWorkbench"
    type="dmg"
    downloadURL="https://dev.mysql.com/get/Downloads/MySQLGUITools/$(curl -s "https://dev.mysql.com/downloads/workbench/?os=33" | grep mysql-workbench-community | head -1 | cut -d\( -f2 | cut -d\) -f1)"
    appNewVersion="$(curl -s 'http://workbench.mysql.com/current-release' | grep fullversion | cut -d\" -f4).CE"
    expectedTeamID="VB5E2TV963"
    ;;

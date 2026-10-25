realvncconnect|\
realvncconnect8)
    name="RealVNC Connect"
    type="pkg"
    downloadURL="https://downloads.realvnc.com/download/file/realvnc-connect/RealVNC-Connect-Latest-MacOSX-universal.pkg"
    appNewVersion="$(curl -sfL "https://realvnc.zendesk.com/api/v2/help_center/en-us/sections/26441433034013/articles.json?per_page=100" | grep -oE '"title":"RealVNC Connect [0-9.]+' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -1)"
    expectedTeamID="ZNCQ8JEH7X"
    blockingProcesses=( "rvncconnect" )
    ;;

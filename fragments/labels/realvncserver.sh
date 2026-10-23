vncconnect|\
realvncserver)
    name="RealVNC Server"
    type="pkg"
    targetDir="/Applications/RealVNC"
    appNewVersion="$(curl -sL https://realvnc.zendesk.com/api/v2/help_center/en-us/articles/5835892358941.json | sed -n 's/.*VNC-Server-\([0-9.]*\)-MacOSX.*/\1/p')"
    downloadURL="https://downloads.realvnc.com/download/file/vnc.files/VNC-Server-$appNewVersion-MacOSX-universal.pkg"
    expectedTeamID="ZNCQ8JEH7X"
    ;;

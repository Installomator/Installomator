vncconnect|\
realvncserver)
    name="Real VNC Server"
    appName="VNC Server.app"
    type="pkg"
    packageID="com.realvnc.vncserver.pkg"
    downloadURL="https://downloads.realvnc.com/download/file/vnc.files/VNC-Server-Latest-MacOSX-universal.pkg"
    appNewVersion="$(curl -sL https://realvnc.zendesk.com/api/v2/help_center/en-us/articles/5835892358941.json | sed -n 's/.*VNC-Server-\([0-9.]*\)-MacOSX.*/\1/p')"
    expectedTeamID="ZNCQ8JEH7X"
    ;;

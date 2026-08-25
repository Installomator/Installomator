realvncviewer)
    name="Real VNC Viewer"
    appName="VNC Viewer.app"
    type="dmg"
    downloadURL="https://downloads.realvnc.com/download/file/viewer.files/VNC-Viewer-Latest-MacOSX-universal.dmg"
    appNewVersion="$(curl -sL https://realvnc.zendesk.com/api/v2/help_center/en-us/articles/5835892358941.json | sed -n 's/.*VNC-Viewer-\([0-9.]*\)-MacOSX.*/\1/p')"
    expectedTeamID="ZNCQ8JEH7X"
    ;;

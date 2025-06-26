realvncviewer)
    name="Real VNC Viewer"
    appName="VNC Viewer.app"
    type="dmg"
    downloadURL="$(curl -sL https://www.realvnc.com/en/connect/download/viewer/ | grep -i 'download-link-path-macos' | sed -r 's/.*href="([^"]+).*/\1/g')"
    appNewVersion="$(echo $downloadURL | sed -n 's:.*VNC-Viewer-\(.*\)-MacOSX.*:\1:p')"
    expectedTeamID="ZNCQ8JEH7X"
    ;;

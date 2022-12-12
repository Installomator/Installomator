zoomgov)
    name="zoom.us"
    type="pkg"
    downloadURL="https://www.zoomgov.com/client/latest/ZoomInstallerIT.pkg"
    appNewVersion="$(curl -fsIL ${downloadURL} | grep -i ^location | cut -d "/" -f5)"
    expectedTeamID="BJ4HAAB9B3"
    versionKey="CFBundleVersion"
    ;;

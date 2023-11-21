zoomoutlookpluginremoval)
    name="Zoom Outlook Plugin Removal"
    type="pkg"
    packageID="com.microsoft.remove.ZoomPlugin"
    downloadURL="https://office-reset.com"$(curl -fs https://office-reset.com/macadmins/ | grep -o -i "href.*\".*\"*ZoomPlugin_Removal.*.pkg" | cut -d '"' -f2)
    expectedTeamID="QGS93ZLCU7"
    ;;

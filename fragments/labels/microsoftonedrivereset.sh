microsoftonedrivereset)
    name="Microsoft OneDrive Reset"
    type="pkg"
    packageID="com.microsoft.reset.OneDrive"
    downloadURL="https://office-reset.com"$(curl -fs https://office-reset.com/macadmins/ | grep -o -i "href.*\".*\"*OneDrive_Reset.*.pkg" | cut -d '"' -f2)
    expectedTeamID="QGS93ZLCU7"
    ;;

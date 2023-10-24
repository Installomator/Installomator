microsoftwordreset)
    name="Microsoft Word Reset"
    type="pkg"
    packageID="com.microsoft.reset.Word"
    downloadURL="https://office-reset.com"$(curl -fs https://office-reset.com/macadmins/ | grep -o -i "href.*\".*\"*Word_Reset.*.pkg" | cut -d '"' -f2)
    expectedTeamID="QGS93ZLCU7"
    ;;

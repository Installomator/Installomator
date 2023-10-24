microsoftexcelreset)
    name="Microsoft Excel Reset"
    type="pkg"
    packageID="com.microsoft.reset.Excel"
    downloadURL="https://office-reset.com"$(curl -fs https://office-reset.com/macadmins/ | grep -o -i "href.*\".*\"*Excel_Reset.*.pkg" | cut -d '"' -f2)
    expectedTeamID="QGS93ZLCU7"
    ;;

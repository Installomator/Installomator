microsoftoutlookreset)
    name="Microsoft Outlook Reset"
    type="pkg"
    packageID="com.microsoft.reset.Outlook"
    downloadURL="https://office-reset.com"$(curl -fs https://office-reset.com/macadmins/ | grep -o -i "href.*\".*\"*Outlook_Reset.*.pkg" | cut -d '"' -f2)
    expectedTeamID="QGS93ZLCU7"
    ;;

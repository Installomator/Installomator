microsoftofficeremoval)
    name="Microsoft Office Removal"
    type="pkg"
    packageID="com.microsoft.remove.Office"
    downloadURL="https://office-reset.com"$(curl -fs https://office-reset.com/macadmins/ | grep -o -i "href.*\".*\"*Office_Removal.*.pkg" | cut -d '"' -f2)
    expectedTeamID="QGS93ZLCU7"
    ;;

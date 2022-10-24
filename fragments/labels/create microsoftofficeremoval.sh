microsoftofficeremoval)
    name="Microsoft Office Removal"
    type="pkg"
    packageID="com.microsoft.remove.Office"
    downloadURL=curl -fs https://office-reset.com/macadmins/ | grep -o -i "href.*\".*\"*_Factory.*.pkg" | cut -d '"' -f2
    expectedTeamID="QGS93ZLCU7"
    ;;

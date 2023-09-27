microsoftonenotereset)
    name="Microsoft OneNote Reset"
    type="pkg"
    packageID="com.microsoft.reset.OneNote"
    downloadURL="https://office-reset.com"$(curl -fs https://office-reset.com/macadmins/ | grep -o -i "href.*\".*\"*OneNote_Reset.*.pkg" | cut -d '"' -f2)
    expectedTeamID="QGS93ZLCU7"
    ;;

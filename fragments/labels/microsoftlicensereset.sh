microsoftlicensereset)
    name="Microsoft License Reset"
    type="pkg"
    packageID="com.microsoft.reset.Credentials"
    downloadURL="https://office-reset.com"$(curl -fs https://office-reset.com/macadmins/ | grep -o -i "href.*\".*\"*License_Reset.*.pkg" | cut -d '"' -f2)
    expectedTeamID="QGS93ZLCU7"
    ;;

microsoftteamsreset)
    name="Microsoft Teams Reset"
    type="pkg"
    packageID="com.microsoft.reset.Teams"
    downloadURL="https://office-reset.com"$(curl -fs https://office-reset.com/macadmins/ | grep -o -i "href.*\".*\"*Teams_Reset.*.pkg" | cut -d '"' -f2)
    expectedTeamID="QGS93ZLCU7"
    ;;

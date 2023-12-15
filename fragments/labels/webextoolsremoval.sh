webextoolsremoval)
    name="WebEx Tools Removal"
    type="pkg"
    packageID="com.microsoft.remove.WebExPT"
    downloadURL="https://office-reset.com"$(curl -fs https://office-reset.com/macadmins/ | grep -o -i "href.*\".*\"*WebExPT_Removal.*.pkg" | cut -d '"' -f2)
    expectedTeamID="QGS93ZLCU7"
    ;;

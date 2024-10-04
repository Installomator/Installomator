foxitpdfreader)
    name="Foxit PDF Reader"
    type="pkg"
    #the packageID versioning seems to be in line with Foxit PDF Editor and does not reflect the installed versionNumber
    #packageID="com.foxit.pkg.pdfreader"
    downloadURL="https://www.foxit.com/downloads/latest.html?product=Foxit-Reader&platform=Mac-OS-X&version=&package_type=&distID="
    appNewVersion="$(curl -fsL "https://www.foxit.com/pdf-reader/version-history.html" | grep -m 1 "name=\"Version" | awk -F "Version_" '{ print $2 }' | awk -F "\"" '{ print $1 }')"
    expectedTeamID="8GN47HTP75"
    ;;

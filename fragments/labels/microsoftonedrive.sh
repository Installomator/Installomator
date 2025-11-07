microsoftonedrive)
    # This version match the Last Released Production version setting of OneDrive update channel. It’s default if no update channel setting for OneDrive updates has been specified. Enterprise (Deferred) is also supported with label “microsoftonedrive-deferred”.
    # https://support.microsoft.com/en-us/office/onedrive-release-notes-845dcf18-f921-435e-bf28-4e24b95e5fc0#OSVersion=Mac
    name="OneDrive"
    type="pkg"
    MAUSource="https://oneclient.sfx.ms/Mac/Prod/b9de6823d5a66c7cc845b2dbf90f4935c002aeaf.xml"
    downloadURL=$(curl -fsL $MAUSource | xmllint --xpath '//array/dict[1]/key[text()="UniversalPkgBinaryURL"]/following-sibling::string[1]/text()' - 2>/dev/null)
    appNewVersion=$(curl -fsL $MAUSource | xmllint --xpath '//array/dict[1]/key[text()="CFBundleShortVersionString"]/following-sibling::string[1]/text()' - 2>/dev/null)
    expectedTeamID="UBF8T346G9"
    ;;

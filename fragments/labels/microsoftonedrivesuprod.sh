microsoftonedrivesuprod)
    # This label uses the same XML feed that the OneDrive StandaloneUpdater tool uses to find the production version of OneDrive updates.
    # Microsoft OneDrive StandaloneUpdater Production
    name="OneDrive"
    type="pkg"
    onedriveFeedData=$(curl -fsL "https://g.live.com/0USSDMC_W5T/StandaloneProductManifest" )
    downloadURL=$(echo "$onedriveFeedData" | xmllint --xpath "string(/plist/dict/key[.='ManifestArray']/following-sibling::array[1]/dict[1]//string[contains(text(),'universal/OneDrive.pkg')])" -)
    appNewVersion=$(echo "$onedriveFeedData" | xmllint --xpath "string(/plist/dict/key[.='ManifestArray']/following-sibling::array[1]/dict[1]/key[.='CFBundleShortVersionString']/following-sibling::string[1])" -)
    expectedTeamID="UBF8T346G9"
    ;;

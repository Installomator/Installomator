googlechromepkg)
    name="Google Chrome"
    type="pkg"
    #
    # Note: this url acknowledges that you accept the terms of service
    # https://support.google.com/chrome/a/answer/9915669
    #
    downloadURL="https://dl.google.com/chrome/mac/stable/accept_tos%3Dhttps%253A%252F%252Fwww.google.com%252Fintl%252Fen_ph%252Fchrome%252Fterms%252F%26_and_accept_tos%3Dhttps%253A%252F%252Fpolicies.google.com%252Fterms/googlechrome.pkg"
    appNewVersion=$(getJSONValue "$(curl -fsL "https://versionhistory.googleapis.com/v1/chrome/platforms/mac/channels/stable/versions/all/releases?filter=fraction%3E0.01,endtime=none&order_by=version%20desc" )" "releases[0].version" )
    expectedTeamID="EQHXZ8M8AV"
    updateTool="/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle/Contents/Resources/GoogleSoftwareUpdateAgent.app/Contents/MacOS/GoogleSoftwareUpdateAgent"
    updateToolArguments=( -runMode oneshot -userInitiated YES )
    updateToolRunAsCurrentUser=1
    ;;

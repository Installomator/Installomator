processing4)
    name="Processing"
    type="zip"
    downloadURL=$(downloadURLFromGit processing processing4)
    appNewVersion=$(versionFromGit processing processing4)
    expectedTeamID="8SBRM6J77J"
    # Github returned version number resulves in build and version numbers being combined, so this provides the best match.
    # if you are manually replicating the label with valuesfromarguements use 'appNewVersion="4.$(versionFromGit processing processing | cut -d "." -f 2-)"' instead.
    appCustomVersion(){ echo "$(defaults read /Applications/Processing.app/Contents/Info.plist CFBundleVersion )$( defaults read /Applications/Processing.app/Contents/Info.plist CFBundleShortVersionString )" }
    ;;

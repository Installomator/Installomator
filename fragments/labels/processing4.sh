processing4)
    name="Processing"
    type="zip"
    archiveName="Processing-[0-9.]*-macOS-$( if [ "$( arch )" = "arm64" ]; then echo "aarch64" ; else echo "x64" ; fi ).zip"
    downloadURL=$(downloadURLFromGit processing processing4)
    appNewVersion=$(versionFromGit processing processing4)
    expectedTeamID="8SBRM6J77J"
    # Github returned version number resolves in build and version numbers being combined, so this provides the best match.
    # if you are manually replicating the label with valuesfromarguements use 'appNewVersion="4.$(versionFromGit processing processing | cut -d "." -f 2-)"' instead.
    appCustomVersion(){ echo "$(defaults read /Applications/Processing.app/Contents/Info.plist CFBundleVersion )$( defaults read /Applications/Processing.app/Contents/Info.plist CFBundleShortVersionString )" }
    ;;

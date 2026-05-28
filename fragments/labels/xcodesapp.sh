xcodesapp)
    name="Xcodes"
    type="zip"
    downloadURL="$(downloadURLFromGit XcodesOrg XcodesApp)"
    appNewVersion="$(versionFromGit XcodesOrg XcodesApp)"
    expectedTeamID="ZU6GR6B2FY"
    appCustomVersion(){appSVS=$(defaults read "/Applications/${name}.app/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null); appBV=$(defaults read "/Applications/${name}.app/Contents/Info.plist" CFBundleVersion 2>/dev/null); echo "${appSVS}${appBV}"}
    ;;

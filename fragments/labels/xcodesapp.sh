xcodesapp)
    name="Xcodes"
    type="zip"
    downloadURL="$(downloadURLFromGit XcodesOrg XcodesApp)"
    appNewVersion="$(versionFromGit XcodesOrg XcodesApp)"
    expectedTeamID="ZU6GR6B2FY"
    appCustomVersion(){appSVS=$(defaults read "/Applications/${name}.app/Contents/Info.plist" CFBundleShortVersionString); appBV=$(defaults read "/Applications/${name}.app/Contents/Info.plist" CFBundleVersion); echo "${appSVS}${appBV}"}
    ;;

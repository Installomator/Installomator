dialog|\
swiftdialog)
    name="Dialog"
    type="pkg"
    packageID="au.csiro.dialogcli"
    downloadURL="$(downloadURLFromGit swiftDialog swiftDialog)"
    appNewVersion="$(versionFromGit swiftDialog swiftDialog | awk -F "-" '{print$1}')"
    expectedTeamID="PWA5E9TQ59"
    ;;

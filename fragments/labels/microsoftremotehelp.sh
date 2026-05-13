microsoftremotehelp)
    name="Microsoft Remote Help"
    type="pkg"
    downloadURL="https://aka.ms/downloadremotehelpmacos"
    versionKey="CFBundleVersion"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i location: | grep -o "Microsoft_Remote_Help.*pkg" | sed -E 's/[a-zA-Z_]*_([0-9.]*)_.*/\1/g')
    expectedTeamID="UBF8T346G9"
    ;;

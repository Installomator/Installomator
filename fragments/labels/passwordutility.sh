passwordutility)
    name="Password Utility"
    type="pkg"
    downloadURL="https://twocanoes-software-updates.s3.amazonaws.com/Password_Utility.pkg"
    appNewVersion=$(curl -fsL "https://data.twocanoes.com/api/version_info" | sed -n 's/.*"com.twocanoes.PasswordUtility".*"version":"\([^"]*\)".*/\1/p')
    expectedTeamID="UXP6YRD6GV"
    ;;

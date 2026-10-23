passwordutility)
    name="Password Utility"
    type="pkg"
    downloadURL="https://twocanoes-software-updates.s3.amazonaws.com/Password_Utility.pkg"
    appNewVersion=$( getJSONValue "$(curl -fsL https://data.twocanoes.com/api/version_info)" "[\"com.twocanoes.PasswordUtility\"].version" )
    expectedTeamID="UXP6YEHSPW"
    ;;

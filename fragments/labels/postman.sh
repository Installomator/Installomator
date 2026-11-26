postman)
    name="Postman"
    type="zip"
    appNewVersion=$(getJSONValue "$(curl -fsL 'https://dl.pstmn.io/api/version/latest')" 'version')
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://dl.pstmn.io/download/version/${appNewVersion}/osx_arm64"
    else
        downloadURL="https://dl.pstmn.io/download/version/${appNewVersion}/osx_64"
    fi
    expectedTeamID="H7H8Q7M5CK"
    ;;

postman)
    name="Postman"
    type="zip"
    curlOptions=( -H "accept-encoding: gzip, deflate, br")
    appNewVersion=$(getJSONValue "$(curl -fsL 'https://mkt.cdn.postman.com/www-next/release-notes/app-release-notes.json')" 'notes[0].version')
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://dl.pstmn.io/download/version/${appNewVersion}/osx_arm64"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://dl.pstmn.io/download/version/${appNewVersion}/osx_64"
    fi
    expectedTeamID="H7H8Q7M5CK"
    ;;

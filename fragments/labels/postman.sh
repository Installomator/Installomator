postman)
    name="Postman"
    type="zip"
    curlOptions=( -H "accept-encoding: gzip, deflate, br")
    if [[ $(arch) == "arm64" ]]; then
    	downloadURL="https://dl.pstmn.io/download/latest/osx_arm64"
	elif [[ $(arch) == "i386" ]]; then
		downloadURL="https://dl.pstmn.io/download/latest/osx_64"
	fi
	appNewVersion=$(getJSONValue "$(curl -fsL 'https://www.postman.com/mkapi/release.json?t=')" 'notes[0].version')
    expectedTeamID="H7H8Q7M5CK"
    ;;

postman)
    name="Postman"
    type="zip"
    if [[ $(arch) == "arm64" ]]; then
    	downloadURL="https://dl.pstmn.io/download/latest/osx_arm64"
		appNewVersion=$(curl -fsL --head "${downloadURL}" | grep "content-disposition:" | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/')
	elif [[ $(arch) == "i386" ]]; then
		downloadURL="https://dl.pstmn.io/download/latest/osx_64"
		appNewVersion=$(curl -fsL --head "${downloadURL}" | grep "content-disposition:" | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/')
	fi
    expectedTeamID="H7H8Q7M5CK"
    ;;

ibarcoder)
    name="iBarcoder"
    type="dmg"
    downloadURL="https://cristallight.com/Downloads/mac/ibarcoder.dmg"
    appNewVersion="$(curl -fs "https://cristallight.com/iBarcoder/" | grep -i version: | head -1 | awk '{print $2}')"
    expectedTeamID="JAXVB9AH9M"
    ;;

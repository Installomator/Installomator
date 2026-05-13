rapidapi)
    name="RapidAPI"
    type="zip"
    downloadURL="https://paw.cloud/download"
    appNewVersion="$(curl -fsIL ${downloadURL} | grep -i ^location | cut -d '/' -f5 | awk -F '-' '{ print $2 }')"
    expectedTeamID="84599RL58A"
    ;;

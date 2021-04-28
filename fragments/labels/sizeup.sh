sizeup)
    # credit: AP Orlebeke (@apizz)
    name="SizeUp"
    type="zip"
    downloadURL="https://www.irradiatedsoftware.com/download/SizeUp.zip"
    appNewVersion=$(curl -fs https://www.irradiatedsoftware.com/updates/notes/SizeUpReleaseNotes.html | grep Version | sed -E 's/.*Version ([0-9.]*) <.*/\1/')
    expectedTeamID="GVZ7RF955D"
    ;;

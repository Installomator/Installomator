daisydisk)
    name="DaisyDisk"
    type="zip"
    downloadURL="https://daisydiskapp.com/downloads/DaisyDisk.zip"
    appNewVersion=$( curl -fs 'https://daisydiskapp.com/downloads/appcastReleaseNotes.php?appEdition=Standard' | grep Version | head -1 | cut -d \> -f 3 | cut -d \< -f 1 | awk '{print $2}' )
    expectedTeamID="4CBU3JHV97"
    ;;

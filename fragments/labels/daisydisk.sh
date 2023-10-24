daisydisk)
    name="DaisyDisk"
    type="zip"
    downloadURL="https://daisydiskapp.com/downloads/DaisyDisk.zip"
    appNewVersion=$( curl -fs 'https://daisydiskapp.com/downloads/appcastReleaseNotes.php?appEdition=Standard' | xmllint --html - 2>/dev/null | grep Version | head -1 | sed -E 's/.*Version ([0-9.]*).*/\1/g' )
    expectedTeamID="4CBU3JHV97"
    ;;

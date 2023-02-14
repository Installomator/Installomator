screamingfrogseospider)
    name="Screaming Frog SEO Spider"
    type="dmg"
    downloadURL=$(curl -fs "https://www.screamingfrog.co.uk/wp-content/themes/screamingfrog/inc/download-modal.php" | grep -i -o "https.*\.dmg" | head -1)
    appNewVersion=$(print "$downloadURL" | sed -E 's/https.*\/[a-zA-Z]*-([0-9.]*)\.dmg/\1/g')".0"
    expectedTeamID="CAHEVC3HZC"
    ;;

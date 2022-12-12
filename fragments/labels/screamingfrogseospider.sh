screamingfrogseospider)
    name="Screaming Frog SEO Spider"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
        platform="Mac - (intel)"
    elif [[ $(arch) == arm64 ]]; then
        platform="Mac - (apple silicon)"
    fi
    downloadURL=$(curl -fs "https://www.screamingfrog.co.uk/wp-content/themes/screamingfrog/inc/download-modal.php" | grep "${platform}" | grep -i -o "https.*\.dmg" | head -1)
    appNewVersion=$(print "$downloadURL" | sed -E 's/https.*\/[a-zA-Z]*-([0-9.]*)\.dmg/\1/g')".0"
    expectedTeamID="CAHEVC3HZC"
    ;;

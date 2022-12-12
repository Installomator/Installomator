sdnotary)
    name="SD Notary"
    type="zip"
    downloadURL=$(curl -fs https://latenightsw.com/sd-notary-notarizing-made-easy/ | grep -io "https://.*/.*\.zip")
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*\/[a-zA-Z]*([0-9.]*)-.*\.zip/\1/g')
    expectedTeamID="Z7S6X96M3X"
    ;;

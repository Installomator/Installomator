amazonkindle)
    name="Kindle"
    type="dmg"
    downloadURL="https://www.amazon.com/kindlemacdownload/ref=klp_mac"
    appNewVersion=$( echo $downloadURL | sed -E 's/.*\/([0-9.]*)\/.*/\1/g')
    expectedTeamID="94KV3E626L"
    ;;

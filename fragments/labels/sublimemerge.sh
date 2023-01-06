sublimemerge)
    # Home: https://www.sublimemerge.com
    # Description: Git Client, done Sublime. Line-by-line Staging. Commit Editing. Unmatched Performance.
    name="Sublime Merge"
    type="zip"
    downloadURL="$(curl -fs "https://www.sublimemerge.com/download_thanks?target=mac#direct-downloads" | grep -io "https://download.*_mac.zip" | head -1)"
    appNewVersion=$(curl -fs https://www.sublimemerge.com/download | grep -i -A 4 "id.*changelog" | grep -io "Build [0-9]*")
    expectedTeamID="Z6D26JE4Y4"
    ;;

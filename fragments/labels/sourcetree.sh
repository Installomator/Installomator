sourcetree)
    name="Sourcetree"
    type="zip"
    downloadURL=$(curl -fs "https://www.sourcetreeapp.com" | grep -i "macURL" | tr '"' '\n' | grep -io "https://.*/Sourcetree.*\.zip" | tail -1)
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*\/Sourcetree_([0-9.]*)_[0-9]*\.zip/\1/g')
    expectedTeamID="UPXU4CQZ5P"
    ;;

whatcable)
    name="WhatCable"
    type="zip"
    archiveName="WhatCable.zip"
    downloadURL=$(downloadURLFromGit "darrylmorley" "whatcable")
    appNewVersion=$(versionFromGit "darrylmorley" "whatcable" | sed 's/^v//')
    expectedTeamID="M4RUJ7W6MP"
    ;;

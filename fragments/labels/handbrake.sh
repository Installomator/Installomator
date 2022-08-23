handbrake)
    name="HandBrake"
    type="dmg"
    archiveName="HandBrake-[0-9.]*.dmg$"
    downloadURL=$(downloadURLFromGit HandBrake HandBrake )
    appNewVersion=$(versionFromGit HandBrake HandBrake )
    expectedTeamID="5X9DE89KYV"
    ;;

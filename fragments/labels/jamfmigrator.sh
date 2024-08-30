jamfmigrator)
    name="jamf-migrator"
    type="zip"
    downloadURL=$(downloadURLFromGit jamf JamfMigrator)
    appNewVersion=$(versionFromGit jamf JamfMigrator)
    expectedTeamID="PS2F6S478M"
    ;;

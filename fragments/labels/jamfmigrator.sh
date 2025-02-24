jamfmigrator|\
jamfreplicator)
    name="Replicator"
    type="zip"
    downloadURL=$(downloadURLFromGit jamf Replicator)
    appNewVersion=$(versionFromGit jamf Replicator)
    expectedTeamID="PS2F6S478M"
    ;;

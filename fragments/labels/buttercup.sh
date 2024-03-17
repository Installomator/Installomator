buttercup)
    name="Buttercup"
    type="zip"
	archiveName="Buttercup-[0-9.]*-mac.zip"
	downloadURL=$(downloadURLFromGit buttercup buttercup-desktop)
    appNewVersion=$(versionFromGit buttercup buttercup-desktop)
    expectedTeamID="9D8F4J769D"
    ;;

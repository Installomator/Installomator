ibmnotifier)
	# NKC Change
	name="IBM Notifier"
	type="zip"
	downloadURL=$(downloadURLFromGit ibm mac-ibm-notifications )
	appNewVersion=$(versionFromGit ibm mac-ibm-notifications )
	expectedTeamID="PETKK2G752"
	targetDir="/usr/local/nkc"
	;;

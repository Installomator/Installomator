ibmnotifier)
    name="IBM Notifier"
    type="zip"
    downloadURL="$(downloadURLFromGit IBM mac-ibm-notifications)"
    #appNewVersion="$(versionFromGit IBM mac-ibm-notifications)"
    appNewVersion="$(curl -sLI "https://github.com/IBM/mac-ibm-notifications/releases/latest" | grep -i "^location" | tr "/" "\n" | tail -1 | cut -d "-" -f2 | sed 's/[^0-9\.]//g')"
    expectedTeamID="PETKK2G752"
    ;;

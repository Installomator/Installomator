jamfcli|\
jamf-cli)
    name="jamf-cli"
    type="pkg"
    downloadURL="$( downloadURLFromGit Jamf-Concepts jamf-cli )"
    appNewVersion="$( versionFromGit Jamf-Concept jamf-cli )"
    expectedTeamID="483DWKW443"
    appName="jamf-cli"
    appCustomVersion() { /usr/local/bin/jamf-cli --version | head -n1 | awk '{ print \$2 }' }
    ;;

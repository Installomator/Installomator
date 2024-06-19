busycontacts)
    name="BusyContacts"
    type="dmg"
    downloadURL="https://www.busymac.com/download/BusyContacts.dmg"
    appNewVersion=$( curl -ILs "https://www.busymac.com/download/BusyContacts.dmg" | grep -m 1 -i '^location' | sed 's/.*bct-//' | sed 's/.dmg//' )
    expectedTeamID="N4RA379GBW"
    appName="BusyContacts.app"
    blockingProcesses=( "BusyContacts" )
    ;;

keeperpasswordmanager)
    name="Keeper Password Manager"
    type="dmg"
    downloadURL="https://www.keepersecurity.com/desktop_electron/Darwin/KeeperSetup.dmg"
    appNewVersion="$(curl -s https://keepersecurity.com/desktop_electron/desktop_electron_version.txt | grep -oE '[0-9.]*')"
    expectedTeamID="234QNB7GCA"
    ;;


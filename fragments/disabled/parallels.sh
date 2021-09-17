parallels)
    # This downloads an installer app, so not really useful here
    name="Parallels Desktop"
    type="dmg"
    downloadURL="https://parallels.com/directdownload/pd15/"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i ^location | tail -1 | cut -d "/" -f6)
    expectedTeamID="4C6364ACXT"
    ;;

flexoptixapp)
    name="FLEXOPTIX App"
    type="dmg"
    downloadURL="https://flexbox.reconfigure.me/download/electron/mac/x64/current"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i ^location | sed -E 's/.*-([0-9.]*)\.dmg/\1/g')
    expectedTeamID="C5JETSFPHL"
    ;;

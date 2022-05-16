mindmanager)
    name="MindManager"
    type="dmg"
    downloadURL="https://www.mindmanager.com/mm-mac-dmg"
    appNewVersion="$(curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*_Mac_*([0-9.]*)\..*/\1/g')"
    expectedTeamID="ZF6ZZ779N5"
    ;;

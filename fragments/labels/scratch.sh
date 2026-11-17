scratch)
    name="Scratch 3"
    downloadURL="https://downloads.scratch.mit.edu/desktop/Scratch.dmg"
    appNewVersion="$(curl -fsIL $downloadURL | grep -i ^location | sed -E 's/.*Scratch%20([0-9.]*)\.dmg/\1/g')"
    type="dmg"
    expectedTeamID="W7AR3WMP87"
    ;;

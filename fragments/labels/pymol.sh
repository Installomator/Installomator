pymol)
    name="PyMOL"
    type="dmg"
    downloadURL=$(curl -s -L "https://pymol.org/" | grep -oE 'href="([^"]*installers/PyMOL-[^"]*-MacOS[^"]*\.dmg)"' | cut -d'"' -f2 | head -1)
    appNewVersion="$(echo "${downloadURL}" | awk -F'/' '{ print $NF }' | awk -F'[-_]' '{ print $2 }')"
    expectedTeamID="26SDDJ756N"
    ;;

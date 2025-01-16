pymol)
    name="PyMOL"
    type="dmg"
    downloadURL=$(curl -s -L "https://pymol.org/" | grep -oE 'href="([^"]*installers/PyMOL-[^"]*-MacOS[^"]*\.dmg)"' | cut -d'"' -f2 | sort -rV | head -n1)
    appNewVersion=$(echo $downloadURL | sed -E 's/.*-([0-9]+\.[0-9]+\.[0-9]+)_[^-]*-MacOS.*/\1/')
    expectedTeamID="26SDDJ756N"
    ;;

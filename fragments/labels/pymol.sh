pymol)
    name="PyMOL"
    type="dmg"
    downloadURL=$(curl -s -L "https://pymol.org/" | grep -m 1 -Eio 'href="https://storage.googleapis.com/pymol-storage/installers/PyMOL-(.*)-MacOS(.*).dmg"' | cut -c7- | sed -e 's/"$//')
    expectedTeamID="26SDDJ756N"
    ;;

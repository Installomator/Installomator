particulars)
    name="Particulars"
    type="pkg"
    packageID="net.glencode.Particulars"
    downloadURL="https://particulars.app/_downloads/Particulars-latest.pkg"
    appNewVersion=$(curl -fsI "${downloadURL}" | grep -i location | grep -oE "[0-9]+\.[0-9]+")
    expectedTeamID="2Z25XDNP2X"
    blockingProcesses=( NONE )
    ;;

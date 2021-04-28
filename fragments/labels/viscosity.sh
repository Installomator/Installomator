viscosity)
    #credit: @matins
    name="Viscosity"
    type="dmg"
    downloadURL="https://www.sparklabs.com/downloads/Viscosity.dmg"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*\/[a-zA-Z.\-]*%20([0-9.]*)\..*/\1/g' )
    expectedTeamID="34XR7GXFPX"
    ;;

redshift)
    name="redshift"
    blockingProcesses=( "Cinema 4D" )
    type="pkg"
    packageID="com.redshift3d.redshift"
    expectedTeamID="4ZY22YGXQG"
    downloadURL=$(curl -fsL https://www.maxon.net/en/downloads | grep -oE '[^"]*redshift[^"]*\.pkg' | head -1)
    appNewVersion=$(sed -n 's/.*redshift_\([^_]*\).*/\1/p' <<< "${downloadURL}")
    ;;

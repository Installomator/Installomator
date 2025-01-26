redshift)
    name="redshift"
    blockingProcesses=( "Cinema 4D" )
    type="pkg"
    packageID="com.redshift3d.redshift"
    expectedTeamID="4ZY22YGXQG"
    appNewVersion="$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.maxon.net/hc/en-us/sections/4405730592274-Redshift" | grep "\-Redshift-" | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+" | sort -Vru | head -1)"
    downloadURL=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://www.maxon.net/en/downloads" | grep -Eo -m 1 "https://installer.maxon.net/installer/rs/redshift_v${appNewVersion}_[a-f0-9]+_macos_metal.pkg")
    ;;

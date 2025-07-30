steinbergmediabay)
    # New installations requires the following labels PRIOR to Cubase
    #    steinbergactivationmanager
    #    steinberglibrarymanager
    #    steinbergmediabay
    #
    name="Steinberg Media Bay"
    type="pkgInDmg"
    packageID="com.steinberg.MediaClient"
    downloadURL="https://www.steinberg.net/smb-mac"
    appNewVersion="$( curl -LIs "${downloadURL}" | grep -i "location:" | grep "dmg" | grep -o '[0-9]\.[0-9]\.[0-9][0-9]')"
    expectedTeamID="5PMY476BJ6"
    ;;

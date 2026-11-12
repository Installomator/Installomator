steinbergcubaseelementsaile13)
    # New installations requires the following labels PRIOR to this label
    #    steinbergactivationmanager
    #    steinberglibrarymanager
    #    steinbergmediabay
    #
    #    Your serial number will determine the version Elements/AI/LE
    name="Cubase LE AI Elements 13"
    type="pkgInDmg"
    packageID="com.steinberg.cubasesoft13"
    cubaseDetails=$(curl -fs "https://o.steinberg.net/en/support/downloads/cubase_13/cubase_elements_13.html")
    downloadURL=$(echo $cubaseDetails | sed -e 's/<a /\n<a /g' | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d' | grep -e "Cubase_LE_AI_Elements_[0-9][0-9].[0-9].[0-9][0-9]_Installer_mac.dmg")
    appNewVersion=$( echo $downloadURL | cut -d_ -f7 )
    appCustomVersion(){ /usr/bin/defaults read "/Applications/Cubase LE AI Elements 13.app/Contents/Info.plist" CFBundleVersion | cut -d'.' -f1-3 }
    expectedTeamID="5PMY476BJ6"
    ;;

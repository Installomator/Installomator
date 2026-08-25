steinbergcubaseproartist13)
    # New installations requires the following labels PRIOR to this label
    #    steinbergactivationmanager
    #    steinberglibrarymanager
    #    steinbergmediabay
    #
    #    Your serial number will determine the version Pro/Artist
    name="Cubase 13"
    type="pkgInDmg"
    cubaseDetails=$(curl -fs "https://o.steinberg.net/en/support/downloads/cubase_13/cubase_pro_13.html")
    downloadURL=$(echo $cubaseDetails | sed -e 's/<a /\n<a /g' | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d' | grep -e "Cubase_[0-9][0-9].[0-9].[0-9][0-9]_Installer_mac.dmg" | head -1)
    appNewVersion=$( echo $downloadURL | cut -d_ -f4 )
    appCustomVersion(){ /usr/bin/defaults read "/Applications/Cubase 13.app/Contents/Info.plist" CFBundleVersion | cut -d'.' -f1-3 }
    expectedTeamID="5PMY476BJ6"
    ;;

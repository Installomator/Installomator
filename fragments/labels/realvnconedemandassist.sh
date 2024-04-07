realvncondemandassist)
    name="On-Demand-Assist-$(curl -sL "https://www.realvnc.help/" | awk -F'"' '/Mac/ && /\.zip/{print $2}' | sed -n 's:.*generic/\(.*\)/.*:\1:p')-MacOSX-universal"
    type="zip"
    downloadURL=$(curl -sL "https://www.realvnc.help/" | awk -F'"' '/Mac/ && /\.zip/{print $2}')
    appNewVersion="$(echo $downloadURL | sed -n 's:.*generic/\(.*\)/.*:\1:p')"
    expectedTeamID="ZNCQ8JEH7X"
    blockingProcesses=( "On-Demand Assist" "$name" )
    appCustomVersion() { echo "$(defaults read "/Applications/On-Demand-Assist-$(curl -sL "https://www.realvnc.help/" | awk -F'"' '/Mac/ && /\.zip/{print $2}' | sed -n 's:.*generic/\(.*\)/.*:\1:p')-MacOSX-universal.app/Contents/Info.plist" CFBundleShortVersionString)" | sed 's/ ([^)]*)//' ; }
    ;;


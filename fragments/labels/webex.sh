webex|\
webexteams)
    # credit: Erik Stam (@erikstam)
    name="Webex"
    type="dmg"
    appNewVersion=$(curl -fs https://help.webex.com/en-us/article/8dmbcr/Webex-App-%7C-What%27s-New | tr '"' "\n" |  grep "Mac—"| head -1|sed 's/[^0-9\.]//g' )
    blockingProcesses=( "Webex" "Webex Teams" "Cisco WebEx Start" "WebexHelper")
    if [[ $(arch) == arm64 ]]; then
        downloadURL="https://binaries.webex.com/webex-macos-apple-silicon/Webex.dmg"
    elif [[ $(arch) == i386 ]]; then
        downloadURL="https://binaries.webex.com/webex-macos-intel/Webex.dmg"
    fi
    expectedTeamID="DE8Y96K9QP"
    ;;

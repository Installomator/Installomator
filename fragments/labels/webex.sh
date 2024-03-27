webex|\
webexteams)
    # credit: Erik Stam (@erikstam)
    name="Webex"
    type="dmg"
    appNewVersion=$(curl -s https://help.webex.com/en-us/article/mqkve8/Webex-App-%7C-Release-notes | grep Mac | head -n 2 | tail -n 1 | cut -d "—" -f 2 | cut -d "<" -f 1)
    blockingProcesses=( "Webex" "Webex Teams" "Cisco WebEx Start" "WebexHelper")
    if [[ $(arch) == arm64 ]]; then
        downloadURL="https://binaries.webex.com/WebexDesktop-MACOS-Apple-Silicon-Gold/Webex.dmg"
    elif [[ $(arch) == i386 ]]; then
        downloadURL="https://binaries.webex.com/WebexTeamsDesktop-MACOS-Gold/Webex.dmg"
    fi
    expectedTeamID="DE8Y96K9QP"
    ;;

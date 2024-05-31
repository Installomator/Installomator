docker)
    name="Docker"
    type="dmg"
    if [[ "$(arch)" == arm64 ]]; then
        downloadURL="https://desktop.docker.com/mac/stable/arm64/Docker.dmg"
        appNewVersion=$( curl -fs "https://desktop.docker.com/mac/main/arm64/appcast.xml" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[last()]' 2>/dev/null | cut -d '"' -f2 )
    elif [[ "$(arch)" == i386 ]]; then
        downloadURL="https://desktop.docker.com/mac/stable/amd64/Docker.dmg"
        appNewVersion=$( curl -fs "https://desktop.docker.com/mac/main/amd64/appcast.xml" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[last()]' 2>/dev/null | cut -d '"' -f2 )
    fi
    CLIInstaller="Docker.app/Contents/MacOS/install"
    CLIArguments=(--accept-license)
    if [[ "${currentUser}" != "loginwindow" ]];then
        CLIArguments+=(--user "${currentUser}")
    fi
    expectedTeamID="9BNSXJN65R"
    blockingProcesses=( "Docker Desktop" )
    ;;

docker)
    name="Docker"
    type="dmg"
    if [[ "$(arch)" == arm64 ]]; then
        dockerXML=$(curl -fs "https://desktop.docker.com/mac/main/arm64/appcast.xml")
        downloadURL=$(echo "$dockerXML" | xpath 'string(//rss/channel/item/enclosure/@url)')
        appNewVersion=$(echo "$dockerXML" | xpath 'string(//rss/channel/item/enclosure/@sparkle:shortVersionString)')
    elif [[ "$(arch)" == i386 ]]; then
        dockerXML=$(curl -fs "https://desktop.docker.com/mac/main/amd64/appcast.xml")
        downloadURL=$(echo "$dockerXML" | xpath 'string(//rss/channel/item/enclosure/@url)')
        appNewVersion=$(echo "$dockerXML" | xpath 'string(//rss/channel/item/enclosure/@sparkle:shortVersionString)')
    fi
    CLIInstaller="Docker.app/Contents/MacOS/install"
    CLIArguments=(--accept-license)
    if [[ "${currentUser}" != "loginwindow" ]];then
        CLIArguments+=(--user "${currentUser}")
    fi
    expectedTeamID="9BNSXJN65R"
    blockingProcesses=( "Docker Desktop" )
    ;;

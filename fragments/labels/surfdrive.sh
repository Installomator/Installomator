surfdrive)
    name="SURFdrive"
    type="pkg"
    downloadURL="https://surfdrive.surf.nl/downloads/surfdrive-latest-x86_64.pkg"
    expectedTeamID="4AP2STM4H5"
    appNewVersion=$(curl -fs https://wiki.surfnet.nl/display/SURFdrive/Downloads+voor+SURFdrive|grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | grep pkg|cut -d- -f2)
    appName="surfdrive.app"
    blockingProcesses=( "surfdrive" )
    ;;

surfdrive)
    name="SURFdrive"
    type="pkg"
    downloadURL=$(curl -fs https://servicedesk.surf.nl/wiki/display/WIKI/Desktop+client+login|grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" |grep $(uname -m)| grep pkg)
    expectedTeamID="4AP2STM4H5"
    appNewVersion=$(curl -fs https://servicedesk.surf.nl/wiki/display/WIKI/Desktop+client+login|grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" |grep $(uname -m)| grep pkg|cut -d- -f2)
    appName="surfdrive.app"
    blockingProcesses=( "surfdrive" )
    ;;

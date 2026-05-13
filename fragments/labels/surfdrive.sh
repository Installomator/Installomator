surfdrive)
    name="SURFdrive"
    type="pkg"
	if [[ $(arch) == "arm64" ]]; then
		downloadURL=$(curl -fs https://servicedesk.surf.nl/wiki/spaces/WIKI/pages/74225443/Desktop+client+login|grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | grep pkg | grep arm64)
		appNewVersion=$(curl -fs https://servicedesk.surf.nl/wiki/spaces/WIKI/pages/74225443/Desktop+client+login|grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | grep pkg | grep arm |cut -d -f2)
    elif [[ $(arch) == "i386" ]]; then
		downloadURL=$(curl -fs https://servicedesk.surf.nl/wiki/spaces/WIKI/pages/74225443/Desktop+client+login|grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | grep pkg | grep x86)
		appNewVersion=$(curl -fs https://servicedesk.surf.nl/wiki/spaces/WIKI/pages/74225443/Desktop+client+login|grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | grep pkg | grep x86|cut -d- -f2)
	fi
    expectedTeamID="4AP2STM4H5"
    appName="surfdrive.app"
    blockingProcesses=( "surfdrive" )
	;;

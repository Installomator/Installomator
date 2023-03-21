zoomoutlookplugin)
    name="Zoom Outlook Plugin"
    appName="PluginLauncher.app"
    targetDir="/Applications/ZoomOutlookPlugin"
    type="pkg"
    downloadURL="https://zoom.us/client/latest/ZoomMacOutlookPlugin.pkg"
    appNewVersion="$(curl -fsIL ${downloadURL} | grep -i ^location | cut -d "/" -f5 | cut -d "." -f1-3)"
    expectedTeamID="BJ4HAAB9B3"
    blockingProcesses=( "PluginLauncher" )
    ;;

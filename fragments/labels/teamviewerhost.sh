teamviewerhost)
    name="TeamViewerHost"
    type="pkgInDmg"
    packageID="com.teamviewer.teamviewerhost"
    pkgName="Install TeamViewerHost.app/Contents/Resources/Install TeamViewerHost.pkg"    downloadURL="https://download.teamviewer.com/download/TeamViewerHost.dmg"
    appNewVersion=$(curl -fs "https://www.teamviewer.com/en/download/mac-os/" | grep "Current version" | cut -d " " -f3 | cut -d "<" -f1)
    expectedTeamID="H7UGFBUGV6"
    #blockingProcessesMaxCPU="5" # Future feature
    ;;

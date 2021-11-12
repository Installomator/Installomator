parallelsdesktop)
    name="Parallels Desktop"
    #appName="Install.app"
    type="dmg"
    downloadURL=$(curl -fs https://update.parallels.com/desktop/v17/parallels/parallels_updates.xml | xpath '(//ParallelsUpdates/Product/Version/Update/FilePath)[1]' 2>/dev/null | grep -oi "https*.*\.dmg")
    appNewVersion=$(curl -fs https://update.parallels.com/desktop/v17/parallels/parallels_updates.xml | xpath '(//ParallelsUpdates/Product/Version/Update/FilePath)[1]' 2>/dev/null | grep -oi "https*.*\.dmg" | cut -d "/" -f6 | cut -d "-" -f1)
    expectedTeamID="4C6364ACXT"
    CLIInstaller="Install.app/Contents/MacOS/Install"
    CLIArguments=(install -t "/Applications/Parallels Desktop.app")
    #Company="Parallels"
    #PatchSkip="YES"
        ;;


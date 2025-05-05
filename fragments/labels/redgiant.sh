redgiant)
    name="Red Giant"
    type="dmg"
    downloadURL=$(curl -fsL https://www.maxon.net/en/downloads | grep -oE '[^"]*redgiant/releases[^"]*\.dmg' | head -1)
    appNewVersion=$(sed -E 's/.*-([0-9.]*)-Mac\.dmg/\1/g' <<< "${downloadURL}")
    expectedTeamID="4ZY22YGXQG"
    appCustomVersion(){
        infoPlist="/Applications/Red Giant/Red Giant/uninstall.app/Contents/Info.plist"
        if [ -f "${infoPlist}" ];then
            defaults read "${infoPlist}" CFBundleVersion
        fi
    }
    installerTool="Red Giant Installer.app"
    CLIInstaller="Red Giant Installer.app/Contents/MacOS/installbuilder.sh"
    CLIArguments=( --mode unattended --unattendedmodeui none )
    ;;

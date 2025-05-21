logioptionsplus)
    name="Logi Options+"
    type="zip"
    downloadURL="https://download01.logi.com/web/ftp/pub/techsupport/optionsplus/logioptionsplus_installer.zip"
    appNewVersion=$(curl -fs "https://support.logi.com/api/v2/help_center/en-us/articles.json?label_names=webcontent=productdownload,webos=mac-macos-x-12.0" | tr "," "\n" | grep -A 10 "macOS" | grep -B 5 -ie "https.*/.*/optionsplus/.*\.zip" | grep "Software Version" | sed 's/\\u[0-9a-z][0-9a-z][0-9a-z][0-9a-z]//g' | grep -ioe "Software Version.*[0-9.]*" | tr "/" "\n" | grep -oe "[0-9.]*" | head -1)
    appCustomVersion(){
        if [ -f "/Applications/logioptionsplus.app" ]; then
            /usr/bin/defaults read "/Applications/logioptionsplus.app/Contents/Info.plist" CFBundleShortVersionString
        fi
    }
    installerTool="logioptionsplus_installer.app"
    CLIInstaller="logioptionsplus_installer.app/Contents/MacOS/logioptionsplus_installer"
    CLIArguments=( "--quiet" )
    expectedTeamID="QED4VVPZWA"
    ;;

logitechoptionsplus)
    name="Logi Options+"
    appName="logioptionsplus.app"
    archiveName="logioptionsplus_installer.zip"
    installerTool="logioptionsplus_installer.app"
    type="zip"
    osMajorVersion=$(sw_vers -productVersion | awk -F "." '{print$1}')
    downloadURL="$(curl -fs "https://support.logi.com/api/v2/help_center/en-us/articles.json?label_names=webcontent=productdownload,webos=mac-macos-x-${osMajorVersion}.0" | tr "," "\n"  | grep  -o "https://.*logioptionsplus.*zip" | head -1)"
    appNewVersion=$(curl -fs "https://support.logi.com/api/v2/help_center/en-us/articles.json?label_names=webcontent=productdownload,webos=mac-macos-x-${osMajorVersion}.0" | tr "," "\n" | grep -A 10 "macOS" | grep -B 5 -ie "https.*/.*/optionsplus/.*\.zip" | grep "Software Version" | sed 's/\\u[0-9a-z][0-9a-z][0-9a-z][0-9a-z]//g' | grep -ioe "Software Version.*[0-9.]*" | tr "/" "\n" | grep -oe "[0-9.]*" | head -1)
    CLIInstaller="logioptionsplus_installer.app/Contents/MacOS/logioptionsplus_installer"
    CLIArguments=(--quiet)
    expectedTeamID="QED4VVPZWA"
    ;;

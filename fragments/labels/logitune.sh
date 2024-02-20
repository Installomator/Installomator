logitune)
    name="LogiTune"
    archiveName="LogiTuneInstaller.dmg"
    appName="LogiTuneInstaller.app"
    type="dmg"
    downloadURL="https://software.vc.logitech.com/downloads/tune/LogiTuneInstaller.dmg"
    appNewVersion=$(curl -fs "https://support.logi.com/api/v2/help_center/en-us/articles.json?label_names=webcontent=productdownload,webos=mac-macos-x-11.0" | tr "," "\n" | grep -A 10 "macOS" | grep -B 5 -ie "https.*/.*/optionsplus/.*\.zip" | grep "Software Version" | sed 's/\\u[0-9a-z][0-9a-z][0-9a-z][0-9a-z]//g' | grep -ioe "Software Version.*[0-9.]*" | tr "/" "\n" | grep -oe "[0-9.]*" | head -1)
    CLIInstaller="LogiTuneInstaller.app/Contents/MacOS/LogiTuneInstaller"
    CLIArguments=(-silent)
    expectedTeamID="QED4VVPZWA"
    ;;

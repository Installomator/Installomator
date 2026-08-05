logitechoptionsplus)
    name="Logi Options+"
    appName="logioptionsplus.app"
    archiveName="logioptionsplus_installer.zip"
    installerTool="logioptionsplus_installer.app"
    type="zip"
    osMajorVersion=$(sw_vers -productVersion | awk -F "." '{print$1}')
    logitechOptionsPlusJSON="$(curl -fs "https://support.logi.com/api/v2/help_center/en-us/articles.json?label_names=webcontent=productdownload,webos=mac-macos-x-${osMajorVersion}.0")"
    logitechOptionsPlusArticle="$(printf "%s\n" "$logitechOptionsPlusJSON" | sed $'s/},{"id"/}\\\n{"id"/g' | grep '"title":"Logi Options+"' | head -1)"
    if [[ -z "$logitechOptionsPlusArticle" ]]; then
        # Logitech sometimes publishes app updates before adding labels for new macOS releases.
        logitechOptionsPlusJSON="$(curl -fs "https://support.logi.com/api/v2/help_center/en-us/articles.json?label_names=webcontent=productdownload")"
        logitechOptionsPlusArticle="$(printf "%s\n" "$logitechOptionsPlusJSON" | sed $'s/},{"id"/}\\\n{"id"/g' | grep '"title":"Logi Options+"' | head -1)"
    fi
    downloadURL="$(printf "%s\n" "$logitechOptionsPlusArticle" | sed 's#\\/#/#g' | grep -o 'https://[^"]*logioptionsplus[^"]*\.zip' | head -1)"
    appNewVersion=$(printf "%s\n" "$logitechOptionsPlusArticle" | sed 's/\\n/ /g;s/<[^>]*>//g' | grep -o 'Software Version: *[0-9][0-9.]*' | head -1 | grep -o '[0-9][0-9.]*')
    CLIInstaller="logioptionsplus_installer.app/Contents/MacOS/logioptionsplus_installer"
    CLIArguments=(--quiet)
    versionKey="CFBundleVersion"
    expectedTeamID="QED4VVPZWA"
    ;;

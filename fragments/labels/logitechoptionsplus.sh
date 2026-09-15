logitechoptionsplus)
    name="Logi Options+"
    appName="logioptionsplus_installer.app"
    type="zip"
    osMajorVersion=$(sw_vers -productVersion | awk -F "." '{print $1}')
    osVersion=$(sw_vers -productVersion | awk -F "." '{if ($1 == "10") print $1"."$2; else print $1".0"}')
    if [[ "$osMajorVersion" -lt 11 ]]; then
        printlog "Logi Options+ download could not be safely verified for this macOS version." ERROR
        cleanupAndExit 95 "Logi Options+ requires a verified macOS 11 or later download" ERROR
    fi
    appNewVersion="$(curl -fs "https://support.logi.com/api/v2/help_center/en-us/articles.json?label_names=webcontent=productdownload,webos=mac-macos-x-${osVersion}" | sed $'s/},{"id"/}\\\n{"id"/g' | awk -F '"body":"' 'index($0, "\"title\":\"Logi Options+\"") {print $2; exit}' | sed 's/\\n/ /g;s/<[^>]*>//g;s/\\"/"/g' | grep -oE 'Software Version: *[0-9]+([.][0-9]+)+' | head -1 | grep -oE '[0-9]+([.][0-9]+)+')"
    if [[ "$osMajorVersion" -ge 14 ]]; then
        downloadURL="https://download01.logi.com/web/ftp/pub/techsupport/optionsplus/logioptionsplus_installer.zip"
    else
        downloadURL="https://download01.logi.com/web/ftp/pub/techsupport/optionsplus/logioptionsplus_installer_${appNewVersion}.zip"
    fi
    CLIInstaller="logioptionsplus_installer.app/Contents/MacOS/logioptionsplus_installer"
    CLIArguments=(--quiet)
    appCustomVersion(){ if [[ -f "/Applications/logioptionsplus.app/Contents/Info.plist" ]]; then /usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "/Applications/logioptionsplus.app/Contents/Info.plist" 2>/dev/null; fi; }
    versionKey="CFBundleVersion"
    expectedTeamID="QED4VVPZWA"
    ;;

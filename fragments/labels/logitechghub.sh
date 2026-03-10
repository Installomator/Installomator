logitechghub|\
logighub)
    name="Logi G-HUB"
    appName="lghub.app"
    archiveName="lghub_installer.zip"
    installerTool="lghub_installer.app"
    type="zip"
    versionKey="CFBundleVersion"
    onlineHTMLinfo=$(curl -fs https://support.logi.com/api/v2/help_center/en-us/articles.json\?label_names\=webcontent\=productdownload,webproduct\=b972df0c-7db0-11e9-b911-fb4b2d0df96c,webos\=mac-macos-x-15.0 | jq -r '.articles|sort_by(.id)|map(select(.name=="Logitech G HUB")).[].body')
    downloadURL=$(echo ${onlineHTMLinfo} | xmllint --html --xpath 'string(//div/div/ul/div/a/@href)' -)
    appNewVersion=$(echo ${onlineHTMLinfo} | grep "Software Version" | grep -o "[0-9].*[0-9]" | sort | tail -1)
    CLIInstaller="lghub_installer.app/Contents/MacOS/lghub_installer"
    CLIArguments=(--silent)
    expectedTeamID="QED4VVPZWA"
    ;;

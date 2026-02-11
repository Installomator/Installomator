logitechghub|\
logighub)
    name="Logi G-HUB"
    appName="lghub.app"
    archiveName="lghub_installer.zip"
    installerTool="lghub_installer.app"
    type="zip"
    versionKey="CFBundleVersion"
    onlineHTMLinfo=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs https://support.logi.com/api/v2/help_center/en-us/articles.json\?label_names\=webcontent\=productdownload,webproduct\=b972df0c-7db0-11e9-b911-fb4b2d0df96c,webos\=mac-macos-x-15.0 | jq -r '.articles.[0].body')
    downloadURL=$(echo ${onlineHTMLinfo} | xmllint --html --xpath 'string(//div/div/ul/div/a/@href)' -)
    appNewVersion=$(echo ${onlineHTMLinfo} | xmllint --html --xpath 'string(//li[b/span= "Software Version: "])' - | tail -1 | awk '{print$3}' -)
    CLIInstaller="lghub_installer.app/Contents/MacOS/lghub_installer"
    CLIArguments=(--silent)
    expectedTeamID="QED4VVPZWA"
    ;;

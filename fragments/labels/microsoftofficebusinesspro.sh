microsoftofficebusinesspro)
    name="MicrosoftOfficeBusinessPro"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=2009112"
    appNewVersion=$(curl -fsILw "%{url_effective}" -o /dev/null "$downloadURL" | sed -E 's|.*_([0-9]+\.[0-9]+\.[0-9]+)_BusinessPro_Installer\.pkg$|\1|')
    appName="Microsoft PowerPoint.app"
    versionKey="CFBundleVersion"
    expectedTeamID="UBF8T346G9"
    blockingProcesses=( "Microsoft AutoUpdate" "Microsoft Word" "Microsoft PowerPoint" "Microsoft Excel" "Microsoft OneNote" "Microsoft Outlook" "OneDrive" "Microsoft Teams" )
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps MSWD2019 XCEL2019 PPT32019 ONMC2019 OPIM2019 ONDR18 TEAMS21 )
    ;;

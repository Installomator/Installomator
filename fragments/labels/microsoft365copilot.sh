microsoft365copilot)
    name="Microsoft 365 Copilot"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=2325438"
    appNewVersion=$(curl -fsLw "%{url_effective}" -o /dev/null "$downloadURL" | awk -F '_' '{print $(NF-1)}')
    versionKey="CFBundleVersion"
    expectedTeamID="UBF8T346G9"
    updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    updateToolArguments=( --install --apps MSCP10 )
    ;;

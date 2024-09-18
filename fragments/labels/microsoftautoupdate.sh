microsoftautoupdate)
    name="Microsoft AutoUpdate"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=830196"
    versionKey="CFBundleVersion"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i location: | grep -o "/Microsoft_.*pkg" | sed -r 's/(.*)\.pkg/\1/g' | sed 's/[^0-9\.]//g')
    expectedTeamID="UBF8T346G9"
    # commented the updatetool for MSAutoupdate, because when Autoupdate is really
    # old or broken, you want to force a new install
    #updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    #updateToolArguments=( --install --apps MSau04 )
    ;;
